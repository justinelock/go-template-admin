package dal

import (
	"context"
	"strings"
	"time"

	"ovra/app/system/internal/dal/model"
	"ovra/toolkit/errx"

	"gorm.io/gorm"
)

const withdrawRefundBusinessNoSuffix = "_WITHDRAW_REFUND"

type withdrawListRow struct {
	ID            int64
	UserID        int64
	OrderNo       string
	Amount        float64
	Status        string
	WithdrawType  string
	BankName      string
	BankCardNo    string
	AccountName   string
	PaymentStatus string
	PaymentNo     string
	PaymentTime   *time.Time
	Remark        string
	RejectReason  string
	CreatedAt     time.Time
	UpdatedAt     time.Time
	Username      string
	Mobile        string
	RealName      string
}

// WithdrawPageQuery 提现列表筛选（对齐 Java selectPageWithUser）
type WithdrawPageQuery struct {
	Status    string
	Type      string
	Keyword   string
	Username  string
	Mobile    string
	RealName  string
	BeginTime string
	EndTime   string
	PageNum   int64
	PageSize  int64
}

// PageWithdraws 分页查 fb_withdraws（JOIN fb_users）
func (d *FbMemberDal) PageWithdraws(ctx context.Context, q WithdrawPageQuery) (rows []withdrawListRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if q.Status != "" {
		where = append(where, "w.status = ?")
		args = append(args, q.Status)
	}
	if q.Type != "" {
		where = append(where, "w.withdraw_type = ?")
		args = append(args, q.Type)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "w.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, `(u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR w.order_no LIKE ?)`)
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
	base := `FROM fb_withdraws w LEFT JOIN fb_users u ON u.id = w.user_id WHERE ` + w
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
	listSQL := `SELECT w.id, w.user_id, w.order_no, w.amount, w.status, w.withdraw_type,
		w.bank_name, w.bank_card_no, w.account_name, w.payment_status, w.payment_no, w.payment_time,
		w.remark, w.reject_reason, w.created_at, w.updated_at,
		COALESCE(u.username, '') AS username, u.mobile, u.real_name ` +
		base + ` ORDER BY w.created_at DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// GetWithdrawByID 按提现主键查询
func (d *FbMemberDal) GetWithdrawByID(ctx context.Context, id int64) (*withdrawListRow, error) {
	if id <= 0 {
		return nil, errx.BizErr("提现订单不存在")
	}
	var row withdrawListRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT w.id, w.user_id, w.order_no, w.amount, w.status, w.withdraw_type,
			w.bank_name, w.bank_card_no, w.account_name, w.payment_status, w.payment_no, w.payment_time,
			w.remark, w.reject_reason, w.created_at, w.updated_at,
			'' AS username, '' AS mobile, '' AS real_name
		FROM fb_withdraws w WHERE w.id = ?`, id).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("提现订单不存在")
	}
	return &row, nil
}

// ApproveWithdraw 批准提现（对齐 Java updateApproved）
func (d *FbMemberDal) ApproveWithdraw(ctx context.Context, id int64) error {
	row, err := d.GetWithdrawByID(ctx, id)
	if err != nil {
		return err
	}
	if row.Status == "SUCCESS" {
		return errx.BizErr("已经完成提现")
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Model(&model.FbWithdraw{}).Where("id = ?", id).Updates(map[string]any{
		"status":         "SUCCESS",
		"payment_status": "SUCCESS",
		"payment_time":   now,
		"updated_at":     now,
	})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("更新提现订单状态失败")
	}
	return nil
}

// RejectWithdraw 拒绝提现并退回主账户余额（对齐 Java updateRejected）
func (d *FbMemberDal) RejectWithdraw(ctx context.Context, id int64, remark string) error {
	if strings.TrimSpace(remark) == "" {
		return errx.BizErr("拒绝理由不能为空")
	}
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var row withdrawListRow
		if err := tx.Raw(`
			SELECT w.id, w.user_id, w.order_no, w.amount, w.status, w.withdraw_type,
				w.bank_name, w.bank_card_no, w.account_name, w.payment_status, w.payment_no, w.payment_time,
				w.remark, w.reject_reason, w.created_at, w.updated_at,
				'' AS username, '' AS mobile, '' AS real_name
			FROM fb_withdraws w WHERE w.id = ? FOR UPDATE`, id).Scan(&row).Error; err != nil {
			return errx.GORMErr(err)
		}
		if row.ID == 0 {
			return errx.BizErr("提现订单不存在")
		}
		refundNo := buildWithdrawRefundBusinessNo(row.OrderNo)
		// 已拒绝：流水已存在则幂等返回
		if row.Status == "REJECTED" {
			var cnt int64
			if err := tx.Raw(`SELECT COUNT(*) FROM fb_account_flow_records WHERE business_no = ?`, refundNo).Scan(&cnt).Error; err != nil {
				return errx.GORMErr(err)
			}
			if cnt > 0 {
				return nil
			}
			return errx.BizErr("提现订单已拒绝，但退款流水不存在，请联系技术支持")
		}
		if row.Status == "SUCCESS" {
			return errx.BizErr("提现订单已通过，无法拒绝")
		}
		if row.Status != "PENDING" {
			return errx.BizErr("订单状态不正确，无法拒绝")
		}
		now := time.Now()
		if err := tx.Model(&model.FbWithdraw{}).Where("id = ?", id).Updates(map[string]any{
			"status":         "REJECTED",
			"payment_status": "REJECTED",
			"reject_reason":  remark,
			"updated_at":     now,
		}).Error; err != nil {
			return errx.GORMErr(err)
		}
		return addBalanceByUserIDTx(tx, row.UserID, row.Amount, refundNo, remark, "提现拒绝退回", "WITHDRAW_FAILED")
	})
}

func buildWithdrawRefundBusinessNo(orderNo string) string {
	return orderNo + withdrawRefundBusinessNoSuffix
}
