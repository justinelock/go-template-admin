package dal

import (
	"context"
	"strings"
	"time"

	"ovra/app/system/internal/dal/model"
	"ovra/toolkit/errx"

	"gorm.io/gorm"
)

type depositListRow struct {
	ID            int64
	UserID        int64
	OrderNo       string
	Amount        float64
	Status        string
	PaymentMethod string
	PaymentStatus string
	PaymentNo     string
	PaymentTime   *time.Time
	Remark        string
	Currency      string
	TargetAccount string
	Screenshot    string
	CreatedAt     time.Time
	UpdatedAt     time.Time
	Username      string
	Mobile        string
	RealName      string
}

// DepositPageQuery 充值列表筛选（对齐 Java selectPageWithUser）
type DepositPageQuery struct {
	Status    string
	Keyword   string
	Username  string
	Mobile    string
	RealName  string
	BeginTime string
	EndTime   string
	PageNum   int64
	PageSize  int64
}

// PageDeposits 分页查 fb_deposits（JOIN fb_users）
func (d *FbMemberDal) PageDeposits(ctx context.Context, q DepositPageQuery) (rows []depositListRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if q.Status != "" {
		where = append(where, "d.status = ?")
		args = append(args, q.Status)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "d.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, `(u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR d.order_no LIKE ?)`)
		like := "%" + kw + "%"
		args = append(args, like, like, like, like)
	}
	if un := strings.TrimSpace(q.Username); un != "" {
		where = append(where, "u.username LIKE ?")
		args = append(args, "%"+un+"%")
	}
	if mob := strings.TrimSpace(q.Mobile); mob != "" {
		where = append(where, "u.mobile LIKE ?")
		args = append(args, "%"+mob+"%")
	}
	if rn := strings.TrimSpace(q.RealName); rn != "" {
		where = append(where, "u.real_name LIKE ?")
		args = append(args, "%"+rn+"%")
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_deposits d LEFT JOIN fb_users u ON u.id = d.user_id WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT d.id, d.user_id, d.order_no, d.amount, d.status, d.payment_method,
		d.payment_status, d.payment_no, d.payment_time, d.remark, d.currency, d.target_account,
		d.screenshot, d.created_at, d.updated_at,
		COALESCE(u.username, '') AS username, u.mobile, u.real_name ` +
		base + ` ORDER BY d.created_at DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// GetDepositByID 按充值主键查询
func (d *FbMemberDal) GetDepositByID(ctx context.Context, id int64) (*depositListRow, error) {
	if id <= 0 {
		return nil, errx.BizErr("充值订单不存在")
	}
	var row depositListRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT d.id, d.user_id, d.order_no, d.amount, d.status, d.payment_method,
			d.payment_status, d.payment_no, d.payment_time, d.remark, d.currency, d.target_account,
			d.screenshot, d.created_at, d.updated_at,
			'' AS username, '' AS mobile, '' AS real_name
		FROM fb_deposits d WHERE d.id = ?`, id).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("充值订单不存在")
	}
	return &row, nil
}

func depositCanAudit(status string) bool {
	s := strings.ToUpper(strings.TrimSpace(status))
	return s == "PENDING" || s == "REVIEWING"
}

// ApproveDeposit 批准充值（对齐 Java updateApproved：先入账再改订单 SUCCESS）
func (d *FbMemberDal) ApproveDeposit(ctx context.Context, id int64) error {
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var row depositListRow
		if err := tx.Raw(`
			SELECT d.id, d.user_id, d.order_no, d.amount, d.status, d.payment_method,
				d.payment_status, d.payment_no, d.payment_time, d.remark, d.currency, d.target_account,
				d.screenshot, d.created_at, d.updated_at,
				'' AS username, '' AS mobile, '' AS real_name
			FROM fb_deposits d WHERE d.id = ? FOR UPDATE`, id).Scan(&row).Error; err != nil {
			return errx.GORMErr(err)
		}
		if row.ID == 0 {
			return errx.BizErr("充值订单不存在")
		}
		if strings.EqualFold(row.Status, "SUCCESS") {
			return errx.BizErr("该笔订单已成功充值")
		}
		if !depositCanAudit(row.Status) {
			return errx.BizErr("订单状态不正确")
		}
		desc := row.Currency + "充值成功"
		if err := depositCreditTx(tx, row.UserID, row.Amount, row.OrderNo, desc, row.Currency, row.TargetAccount); err != nil {
			return err
		}
		now := time.Now()
		if err := tx.Model(&model.FbDeposit{}).Where("id = ?", id).Updates(map[string]any{
			"status":         "SUCCESS",
			"payment_status": "SUCCESS",
			"payment_time":   now,
			"updated_at":     now,
		}).Error; err != nil {
			return errx.GORMErr(err)
		}
		return nil
	})
}

// RejectDeposit 拒绝充值（对齐 Java updateRejected：status CANCELLED，理由写 remark）
func (d *FbMemberDal) RejectDeposit(ctx context.Context, id int64, remark string) error {
	if strings.TrimSpace(remark) == "" {
		return errx.BizErr("拒绝理由不能为空")
	}
	row, err := d.GetDepositByID(ctx, id)
	if err != nil {
		return err
	}
	if strings.EqualFold(row.Status, "SUCCESS") {
		return errx.BizErr("该笔订单已处理")
	}
	if !depositCanAudit(row.Status) {
		return errx.BizErr("订单状态不正确，无法拒绝")
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Model(&model.FbDeposit{}).Where("id = ?", id).Updates(map[string]any{
		"status":         "CANCELLED",
		"payment_status": "CANCELLED",
		"remark":         remark,
		"updated_at":     now,
	})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("更新订单状态失败")
	}
	return nil
}

// mapTargetAccountType 将订单 target_account 映射为 fb_user_wallets.account_type
func mapTargetAccountType(targetAccount string) string {
	switch strings.ToUpper(strings.TrimSpace(targetAccount)) {
	case "MAIN":
		return "main"
	case "FOREX":
		return "forex"
	default:
		return strings.ToLower(strings.TrimSpace(targetAccount))
	}
}
