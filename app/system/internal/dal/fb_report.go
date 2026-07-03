package dal

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
)

// ReportPageQuery 用户报表分页筛选（对齐 Java FbUserReportServiceImpl.getWrapper）
type ReportPageQuery struct {
	Keyword    string
	Username   string
	Level      string
	Status     string
	Verified   string
	BeginTime  string
	EndTime    string
	OrderField string
	Order      string
	PageNum    int64
	PageSize   int64
}

type reportUserRow struct {
	ID        int64
	Username  string
	Mobile    string
	RealName  string
	Level     int32
	ParentID  int64
	CreatedAt time.Time
	LastLogin *time.Time
}

type memberReportRow struct {
	ID             int64
	UserID         int64
	Username       string
	Mobile         string
	RealName       string
	Level          int32
	Amount         float64
	RechargeAmount float64
	WithdrawAmount float64
	RechargeDiff   float64
	TotalProfit    float64
	TeamCount      int32
	RegisterTime   time.Time
	LastLogin      *time.Time
	LoginIP        string
	ParentID       int64
	ParentUsername string
}

type userAmountRow struct {
	UserID int64
	Total  float64
}

type userCountRow struct {
	ParentID int64
	Count    int64
}

type userLoginIpRow struct {
	UserID  int64
	LoginIP string
}

type parentUserRow struct {
	ID       int64
	Username string
}

// reportUserWhere 报表用户筛选：keyword 精确匹配 username/mobile/real_name
func reportUserWhere(q ReportPageQuery) (string, []any) {
	where := []string{"u.flag = 0"}
	var args []any
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, "(u.username = ? OR u.mobile = ? OR u.real_name = ?)")
		args = append(args, kw, kw, kw)
	}
	if st := strings.TrimSpace(q.Status); st != "" {
		where = append(where, "u.status = ?")
		args = append(args, st)
	}
	if v := strings.TrimSpace(q.Verified); v != "" {
		where = append(where, "u.verified = ?")
		args = append(args, v)
	}
	if lv := strings.TrimSpace(q.Level); lv != "" {
		where = append(where, "u.level = ?")
		args = append(args, lv)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "u.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	return strings.Join(where, " AND "), args
}

// reportOrderBy 排序白名单，默认 created_at DESC
func reportOrderBy(q ReportPageQuery) string {
	fieldMap := map[string]string{
		"created_at": "u.created_at",
		"last_login": "u.last_login",
		"level":      "u.level",
		"username":   "u.username",
	}
	col := fieldMap[strings.TrimSpace(q.OrderField)]
	if col == "" {
		return "u.created_at DESC"
	}
	if strings.EqualFold(strings.TrimSpace(q.Order), "asc") {
		return col + " ASC"
	}
	return col + " DESC"
}

func sqlInPlaceholders(n int) string {
	if n <= 0 {
		return ""
	}
	return strings.Repeat("?,", n-1) + "?"
}

// PageReports 用户报表两阶段分页：先查 fb_users，再批量聚合指标
func (d *FbMemberDal) PageReports(ctx context.Context, q ReportPageQuery) (rows []memberReportRow, total int64, err error) {
	where, args := reportUserWhere(q)
	base := "FROM fb_users u WHERE " + where
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT u.id, u.username, u.mobile, u.real_name, u.level,
		COALESCE(u.parent_id, 0) AS parent_id, u.created_at, u.last_login ` +
		base + " ORDER BY " + reportOrderBy(q) + " LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	var users []reportUserRow
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&users).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if len(users) == 0 {
		return []memberReportRow{}, total, nil
	}

	userIDs := make([]int64, 0, len(users))
	parentIDSet := make(map[int64]struct{})
	for _, u := range users {
		userIDs = append(userIDs, u.ID)
		if u.ParentID > 0 {
			parentIDSet[u.ParentID] = struct{}{}
		}
	}

	loginIPMap, err := d.latestLoginIpByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	profitMap, err := d.sumProfitByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	teamCountMap, err := d.teamCountByParentIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	balanceMap, err := d.sumBalanceByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	depositMap, err := d.sumDepositByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	withdrawMap, err := d.sumWithdrawByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}

	parentIDs := make([]int64, 0, len(parentIDSet))
	for pid := range parentIDSet {
		parentIDs = append(parentIDs, pid)
	}
	parentMap, err := d.parentUsersByIds(ctx, parentIDs)
	if err != nil {
		return nil, 0, err
	}

	rows = make([]memberReportRow, 0, len(users))
	for _, u := range users {
		recharge := depositMap[u.ID]
		withdraw := withdrawMap[u.ID]
		row := memberReportRow{
			ID:             u.ID,
			UserID:         u.ID,
			Username:       u.Username,
			Mobile:         u.Mobile,
			RealName:       u.RealName,
			Level:          u.Level,
			Amount:         balanceMap[u.ID],
			RechargeAmount: recharge,
			WithdrawAmount: withdraw,
			RechargeDiff:   recharge - withdraw,
			TotalProfit:    profitMap[u.ID],
			TeamCount:      int32(teamCountMap[u.ID]),
			RegisterTime:   u.CreatedAt,
			LastLogin:      u.LastLogin,
			LoginIP:        loginIPMap[u.ID],
			ParentID:       u.ParentID,
		}
		if p, ok := parentMap[u.ParentID]; ok {
			row.ParentUsername = p.Username
		}
		rows = append(rows, row)
	}
	return rows, total, nil
}

// latestLoginIpByUserIds 按 MAX(login_time) 取最近登录 IP（对齐 selectLatestByUserIds）
func (d *FbMemberDal) latestLoginIpByUserIds(ctx context.Context, userIDs []int64) (map[int64]string, error) {
	out := make(map[int64]string)
	if len(userIDs) == 0 {
		return out, nil
	}
	ph := sqlInPlaceholders(len(userIDs))
	args := int64SliceToAny(userIDs)
	sql := fmt.Sprintf(`
		SELECT d.user_id, d.login_ip
		FROM fb_device_login_log d
		INNER JOIN (
			SELECT user_id, MAX(login_time) AS latest_time
			FROM fb_device_login_log
			WHERE user_id IN (%s)
			GROUP BY user_id
		) t ON d.user_id = t.user_id AND d.login_time = t.latest_time`, ph)
	var list []userLoginIpRow
	if err := d.db.WithContext(ctx).Raw(sql, args...).Scan(&list).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range list {
		out[r.UserID] = r.LoginIP
	}
	return out, nil
}

// sumProfitByUserIds 累计盈亏（对齐 getTotalProfitByUserIds）
func (d *FbMemberDal) sumProfitByUserIds(ctx context.Context, userIDs []int64) (map[int64]float64, error) {
	return d.sumAmountByUserIds(ctx, userIDs, `
		SELECT user_id, SUM(amount) AS total
		FROM fb_profit_records
		WHERE user_id IN (%s)
		GROUP BY user_id`)
}

// teamCountByParentIds 直属下级人数（对齐 getTeamCountByParentIds）
func (d *FbMemberDal) teamCountByParentIds(ctx context.Context, parentIDs []int64) (map[int64]int64, error) {
	out := make(map[int64]int64)
	if len(parentIDs) == 0 {
		return out, nil
	}
	ph := sqlInPlaceholders(len(parentIDs))
	args := int64SliceToAny(parentIDs)
	sql := fmt.Sprintf(`
		SELECT parent_id, COUNT(*) AS count
		FROM fb_users
		WHERE parent_id IN (%s) AND flag = 0
		GROUP BY parent_id`, ph)
	var list []userCountRow
	if err := d.db.WithContext(ctx).Raw(sql, args...).Scan(&list).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range list {
		out[r.ParentID] = r.Count
	}
	return out, nil
}

// sumBalanceByUserIds 钱包余额汇总（对齐 getBalanceByUserIds）
func (d *FbMemberDal) sumBalanceByUserIds(ctx context.Context, userIDs []int64) (map[int64]float64, error) {
	return d.sumAmountByUserIds(ctx, userIDs, `
		SELECT user_id, SUM(balance) AS total
		FROM fb_user_wallets
		WHERE user_id IN (%s)
		GROUP BY user_id`)
}

// sumDepositByUserIds 成功充值汇总（对齐 getSumRechargeGroupByUserIds）
func (d *FbMemberDal) sumDepositByUserIds(ctx context.Context, userIDs []int64) (map[int64]float64, error) {
	return d.sumAmountByUserIds(ctx, userIDs, `
		SELECT user_id, SUM(amount) AS total
		FROM fb_deposits
		WHERE status = 'SUCCESS' AND user_id IN (%s)
		GROUP BY user_id`)
}

// sumWithdrawByUserIds 成功提现汇总（对齐 getSumWithdrawGroupByUserIds）
func (d *FbMemberDal) sumWithdrawByUserIds(ctx context.Context, userIDs []int64) (map[int64]float64, error) {
	return d.sumAmountByUserIds(ctx, userIDs, `
		SELECT user_id, SUM(amount) AS total
		FROM fb_withdraws
		WHERE status = 'SUCCESS' AND user_id IN (%s)
		GROUP BY user_id`)
}

func (d *FbMemberDal) sumAmountByUserIds(ctx context.Context, userIDs []int64, tpl string) (map[int64]float64, error) {
	out := make(map[int64]float64)
	if len(userIDs) == 0 {
		return out, nil
	}
	ph := sqlInPlaceholders(len(userIDs))
	args := int64SliceToAny(userIDs)
	sql := fmt.Sprintf(tpl, ph)
	var list []userAmountRow
	if err := d.db.WithContext(ctx).Raw(sql, args...).Scan(&list).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range list {
		out[r.UserID] = r.Total
	}
	return out, nil
}

// parentUsersByIds 批量查上级用户名
func (d *FbMemberDal) parentUsersByIds(ctx context.Context, ids []int64) (map[int64]parentUserRow, error) {
	out := make(map[int64]parentUserRow)
	if len(ids) == 0 {
		return out, nil
	}
	ph := sqlInPlaceholders(len(ids))
	args := int64SliceToAny(ids)
	sql := fmt.Sprintf(`SELECT id, username FROM fb_users WHERE id IN (%s)`, ph)
	var list []parentUserRow
	if err := d.db.WithContext(ctx).Raw(sql, args...).Scan(&list).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range list {
		out[r.ID] = r
	}
	return out, nil
}

func int64SliceToAny(ids []int64) []any {
	args := make([]any, len(ids))
	for i, id := range ids {
		args[i] = id
	}
	return args
}

// AccountFlowPageQuery 账户流水分页筛选（对齐 Java FbAccountFlowRecordsDao.selectPageWithUser）
type AccountFlowPageQuery struct {
	UserID    string
	Status    string
	FlowType  string // Java 参数名 type
	Currency  string
	Keyword   string
	Username  string
	Mobile    string
	RealName  string
	BeginTime string
	EndTime   string
	PageNum   int64
	PageSize  int64
}

type memberFlowRow struct {
	ID           int64
	UserID       int64
	Username     string
	Mobile       string
	RealName     string
	AccountType  string
	FlowType     string
	BeforeAmount float64
	FlowAmount   float64
	AfterAmount  float64
	BusinessNo   string
	Remark       string
	CreatedAt    time.Time
	WalletID     int64
	Currency     string
	Description  string
	Status       string
	UpdatedAt    *time.Time
}

// accountFlowWhere 构建流水 WHERE（JOIN fb_users）
func accountFlowWhere(q AccountFlowPageQuery) (string, []any) {
	where := []string{"1=1"}
	var args []any
	if uid := strings.TrimSpace(q.UserID); uid != "" {
		where = append(where, "f.user_id = ?")
		args = append(args, uid)
	}
	if st := strings.TrimSpace(q.Status); st != "" {
		where = append(where, "f.status = ?")
		args = append(args, st)
	}
	if ft := strings.TrimSpace(q.FlowType); ft != "" {
		where = append(where, "f.flow_type = ?")
		args = append(args, ft)
	}
	if cur := strings.TrimSpace(q.Currency); cur != "" {
		where = append(where, "f.currency = ?")
		args = append(args, cur)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "f.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, `(
			u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR f.business_no LIKE ?
		)`)
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
	return strings.Join(where, " AND "), args
}

// PageAccountFlow 账户流水分页（对齐 selectPageWithUser；userId 可选，报表抽屉必传）
func (d *FbMemberDal) PageAccountFlow(ctx context.Context, q AccountFlowPageQuery) (rows []memberFlowRow, total int64, err error) {
	where, args := accountFlowWhere(q)
	base := `FROM fb_account_flow_records f LEFT JOIN fb_users u ON u.id = f.user_id WHERE ` + where
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT f.id, f.user_id, u.username, u.mobile, u.real_name, f.account_type, f.flow_type,
		f.before_amount, f.flow_amount, f.after_amount, f.business_no, f.remark, f.created_at,
		COALESCE(f.wallet_id, 0) AS wallet_id, f.currency, f.description, f.status, f.updated_at ` +
		base + " ORDER BY f.created_at DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// GetAccountFlowByID 按流水主键查详情（对齐 Java GET /fbaccountflowrecords/{id}）
func (d *FbMemberDal) GetAccountFlowByID(ctx context.Context, id int64) (*memberFlowRow, error) {
	if id <= 0 {
		return nil, errx.BizErr("流水记录不存在")
	}
	var row memberFlowRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT f.id, f.user_id, u.username, u.mobile, u.real_name, f.account_type, f.flow_type,
			f.before_amount, f.flow_amount, f.after_amount, f.business_no, f.remark, f.created_at,
			COALESCE(f.wallet_id, 0) AS wallet_id, f.currency, f.description, f.status, f.updated_at
		FROM fb_account_flow_records f
		LEFT JOIN fb_users u ON u.id = f.user_id
		WHERE f.id = ?`, id).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("流水记录不存在")
	}
	return &row, nil
}
