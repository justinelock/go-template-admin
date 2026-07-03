package dal

import (
	"context"
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"

	"ovra/toolkit/errx"

	"gorm.io/gorm"
)

type walletApplyListRow struct {
	ID                  int64
	UserID              int64
	Username            string
	Mobile              string
	RealName            string
	AccountType         string
	Status              string
	State               string
	RiskAssessmentScore int32
	RejectReason        string
	ApplyTime           time.Time
	AuditTime           *time.Time
	AuditUserID         int64
	AuditUser           string
	Remark              string
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

type walletApplyAppRow struct {
	ID                  int64
	UserID              int64
	AccountType         string
	Status              string
	RiskAssessmentScore int32
	RejectReason        string
	ApplyTime           time.Time
	AuditTime           *time.Time
	Remark              string
}

type walletApplyUserRow struct {
	Username         string
	Email            string
	SecurityQuestion string
	SecurityAnswer   string
	Verified         int32
}

type walletApplyFlowMonthRow struct {
	FlowType   string
	FlowAmount float64
	Status     string
}

type walletApplyLoginRow struct {
	LoginTime     time.Time
	LoginIP       string
	LoginLocation string
}

// WalletApplyListFilter 钱包申请列表筛选（对齐 Java selectPageWithUser）
type WalletApplyListFilter struct {
	Keyword     string
	Status      string
	State       string
	Verified    string
	UserId      string
	Username    string
	Mobile      string
	RealName    string
	AccountType string
	BeginTime   string
	EndTime     string
	PageNum     int64
	PageSize    int64
}

// PageWalletApplications 分页查 fb_account_application（对齐 selectPageWithUser）
func (d *FbMemberDal) PageWalletApplications(ctx context.Context, f WalletApplyListFilter) (rows []walletApplyListRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if f.Status != "" {
		where = append(where, "a.status = ?")
		args = append(args, f.Status)
	}
	if f.State != "" {
		where = append(where, "a.state = ?")
		args = append(args, f.State)
	}
	if f.Verified != "" {
		where = append(where, "u.verified = ?")
		args = append(args, f.Verified)
	}
	if f.UserId != "" {
		where = append(where, "a.user_id = ?")
		args = append(args, f.UserId)
	}
	if f.AccountType != "" {
		where = append(where, "a.account_type = ?")
		args = append(args, f.AccountType)
	}
	// Java：startTime/endTime 同时存在时用 a.created_at BETWEEN
	if f.BeginTime != "" && f.EndTime != "" {
		where = append(where, "a.created_at BETWEEN ? AND ?")
		args = append(args, f.BeginTime, f.EndTime)
	}
	if kw := strings.TrimSpace(f.Keyword); kw != "" {
		where = append(where, `(u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ?)`)
		like := "%" + kw + "%"
		args = append(args, like, like, like)
	}
	if un := strings.TrimSpace(f.Username); un != "" {
		where = append(where, "u.username LIKE ?")
		args = append(args, "%"+un+"%")
	}
	if mob := strings.TrimSpace(f.Mobile); mob != "" {
		where = append(where, "u.mobile LIKE ?")
		args = append(args, "%"+mob+"%")
	}
	if rn := strings.TrimSpace(f.RealName); rn != "" {
		where = append(where, "u.real_name LIKE ?")
		args = append(args, "%"+rn+"%")
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_account_application a
		LEFT JOIN fb_users u ON u.id = a.user_id
		LEFT JOIN sys_user su ON su.user_id = CAST(a.audit_user_id AS CHAR)
		WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if f.PageSize <= 0 {
		f.PageSize = 10
	}
	if f.PageNum <= 0 {
		f.PageNum = 1
	}
	offset := (f.PageNum - 1) * f.PageSize
	listSQL := `SELECT a.id, a.user_id, a.account_type, a.status, a.state,
		COALESCE(a.risk_assessment_score, 0) AS risk_assessment_score, a.reject_reason,
		a.apply_time, a.audit_time, COALESCE(a.audit_user_id, 0) AS audit_user_id,
		a.remark, a.created_at, a.updated_at,
		COALESCE(u.username, '') AS username, u.mobile, u.real_name,
		COALESCE(su.username, '') AS audit_user ` + base + ` ORDER BY a.created_at DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), f.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// GetWalletApplicationByID 按申请主键查行（详情入口）
func (d *FbMemberDal) GetWalletApplicationByID(ctx context.Context, id int64) (*walletApplyAppRow, error) {
	if id <= 0 {
		return nil, errx.BizErr("申请记录不存在")
	}
	var row walletApplyAppRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT id, user_id, account_type, status,
			COALESCE(risk_assessment_score, 0) AS risk_assessment_score,
			reject_reason, apply_time, audit_time, remark
		FROM fb_account_application WHERE id = ?`, id).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("申请记录不存在")
	}
	return &row, nil
}

// GetWalletApplyUserSecurity 用户实名/密保/邮箱（安全评分用）
func (d *FbMemberDal) GetWalletApplyUserSecurity(ctx context.Context, userID int64) (*walletApplyUserRow, error) {
	var row walletApplyUserRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT username, COALESCE(email, '') AS email,
			COALESCE(security_question, '') AS security_question,
			COALESCE(security_answer, '') AS security_answer,
			COALESCE(verified, 0) AS verified
		FROM fb_users WHERE id = ? AND flag = 0`, userID).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// HasVerifiedIdentity 是否已通过实名（fb_identity_verify VERIFIED）
func (d *FbMemberDal) HasVerifiedIdentity(ctx context.Context, userID int64) (bool, error) {
	var cnt int64
	err := d.db.WithContext(ctx).Raw(`
		SELECT COUNT(*) FROM fb_identity_verify
		WHERE user_id = ? AND status = 'VERIFIED'`, userID).Scan(&cnt).Error
	if err != nil {
		return false, errx.GORMErr(err)
	}
	return cnt > 0, nil
}

// CalcWalletApplySecurityScore 对齐 Java calculateSecurityScore
func CalcWalletApplySecurityScore(identityVerified, twoFactorEnabled, bindEmail bool) int64 {
	score := int64(20) // Java 基础 +20
	if identityVerified {
		score += 30
	}
	if twoFactorEnabled {
		score += 30
	}
	if bindEmail {
		score += 20
	}
	if score > 100 {
		return 100
	}
	return score
}

// ListCurrentMonthFlows 当月账户流水（对齐 getCurrentMonthList，仅 created_at >= 月初）
func (d *FbMemberDal) ListCurrentMonthFlows(ctx context.Context, userID int64) ([]walletApplyFlowMonthRow, error) {
	now := time.Now()
	start := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, now.Location())
	var rows []walletApplyFlowMonthRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT flow_type, flow_amount, COALESCE(status, '') AS status
		FROM fb_account_flow_records
		WHERE user_id = ? AND created_at >= ?
		ORDER BY created_at DESC`,
		userID, start).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return rows, nil
}

// ListCurrentMonthFlowDetails 当月流水全量详情（抽屉展示，对齐 Java getCurrentMonthList）
func (d *FbMemberDal) ListCurrentMonthFlowDetails(ctx context.Context, userID int64) ([]memberFlowRow, error) {
	if userID <= 0 {
		return nil, errx.BizErr("用户ID不能为空")
	}
	now := time.Now()
	start := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, now.Location())
	var rows []memberFlowRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT f.id, f.user_id, u.username, u.mobile, u.real_name, f.account_type, f.flow_type,
			f.before_amount, f.flow_amount, f.after_amount, f.business_no, f.remark, f.created_at,
			COALESCE(f.wallet_id, 0) AS wallet_id, f.currency, f.description, f.status, f.updated_at
		FROM fb_account_flow_records f
		LEFT JOIN fb_users u ON u.id = f.user_id
		WHERE f.user_id = ? AND f.created_at >= ?
		ORDER BY f.created_at DESC`, userID, start).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return rows, nil
}

// ListRecentLoginLogs 最近登录记录（对齐 getRecentList）
func (d *FbMemberDal) ListRecentLoginLogs(ctx context.Context, userID int64, limit int) ([]walletApplyLoginRow, error) {
	if limit <= 0 {
		limit = 10
	}
	var rows []walletApplyLoginRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT login_time, login_ip, COALESCE(login_location, '') AS login_location
		FROM fb_device_login_log
		WHERE user_id = ?
		ORDER BY login_time DESC
		LIMIT ?`, userID, limit).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return rows, nil
}

// CountCurrentMonthLogins 本月登录次数
func (d *FbMemberDal) CountCurrentMonthLogins(ctx context.Context, userID int64) (int64, error) {
	now := time.Now()
	start := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, now.Location())
	var cnt int64
	err := d.db.WithContext(ctx).Raw(`
		SELECT COUNT(*) FROM fb_device_login_log
		WHERE user_id = ? AND login_time >= ? AND login_time <= ?`,
		userID, start, now).Scan(&cnt).Error
	if err != nil {
		return 0, errx.GORMErr(err)
	}
	return cnt, nil
}

// WalletApplyLoginLogFilter 钱包申请登录记录筛选（对齐 Java selectPageWithUser）
type WalletApplyLoginLogFilter struct {
	UserID    string
	Status    string
	Keyword   string
	Username  string
	RealName  string
	BeginTime string
	EndTime   string
	PageNum   int64
	PageSize  int64
}

// PageWalletApplyLoginLogs 按用户分页查登录记录（JOIN 条件 d.user_id > 0）
func (d *FbMemberDal) PageWalletApplyLoginLogs(ctx context.Context, f WalletApplyLoginLogFilter) (rows []memberLoginLogRow, total int64, err error) {
	if strings.TrimSpace(f.UserID) == "" {
		return nil, 0, errx.BizErr("用户ID不能为空")
	}
	where := []string{"1=1"}
	var args []any
	where = append(where, "d.user_id = ?")
	args = append(args, f.UserID)
	if f.Status != "" {
		where = append(where, "d.login_result = ?")
		args = append(args, f.Status)
	}
	if f.BeginTime != "" && f.EndTime != "" {
		where = append(where, "d.login_time BETWEEN ? AND ?")
		args = append(args, f.BeginTime, f.EndTime)
	}
	if kw := strings.TrimSpace(f.Keyword); kw != "" {
		where = append(where, `(u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR d.login_ip LIKE ?)`)
		like := "%" + kw + "%"
		args = append(args, like, like, like, like)
	}
	if un := strings.TrimSpace(f.Username); un != "" {
		where = append(where, "u.username LIKE ?")
		args = append(args, "%"+un+"%")
	}
	if rn := strings.TrimSpace(f.RealName); rn != "" {
		where = append(where, "u.real_name LIKE ?")
		args = append(args, "%"+rn+"%")
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_device_login_log d LEFT JOIN fb_users u ON u.id = d.user_id AND d.user_id > 0 WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if f.PageSize <= 0 {
		f.PageSize = 10
	}
	if f.PageNum <= 0 {
		f.PageNum = 1
	}
	offset := (f.PageNum - 1) * f.PageSize
	listSQL := `SELECT d.id, d.user_id, u.username, u.real_name, d.device_id, d.login_time,
		d.login_ip, d.login_location, d.login_type, d.login_result, d.fail_reason, d.risk_level, d.risk_detail ` +
		base + ` ORDER BY d.login_time DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), f.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// PageLoginLogsByUserID 按用户分页查登录记录（钱包申请操作抽屉）
func (d *FbMemberDal) PageLoginLogsByUserID(ctx context.Context, userID int64, pageNum, pageSize int64) (rows []memberLoginLogRow, total int64, err error) {
	if userID <= 0 {
		return nil, 0, errx.BizErr("用户ID不能为空")
	}
	base := `FROM fb_device_login_log l LEFT JOIN fb_users u ON u.id = l.user_id WHERE l.user_id = ?`
	args := []any{userID}
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if pageSize <= 0 {
		pageSize = 10
	}
	if pageNum <= 0 {
		pageNum = 1
	}
	offset := (pageNum - 1) * pageSize
	listSQL := `SELECT l.id, l.user_id, u.username, u.real_name, l.device_id, l.login_time,
		l.login_ip, l.login_location, l.login_type, l.login_result, l.fail_reason, l.risk_level, l.risk_detail ` +
		base + ` ORDER BY l.login_time DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), pageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// BuildWalletApplyFlowStats 聚合当月流水统计
func BuildWalletApplyFlowStats(flows []walletApplyFlowMonthRow) (monthCount int64, income, expense, dailyAvg float64, successRate string, typeMap map[string]int64) {
	typeMap = make(map[string]int64)
	monthCount = int64(len(flows))
	if monthCount == 0 {
		return 0, 0, 0, 0, "0.00", typeMap
	}
	var totalAbs float64
	var success int64
	for _, f := range flows {
		if f.FlowAmount > 0 {
			income += f.FlowAmount
		} else {
			expense += math.Abs(f.FlowAmount)
		}
		totalAbs += math.Abs(f.FlowAmount)
		if f.FlowType != "" {
			typeMap[f.FlowType]++
		}
		if strings.EqualFold(f.Status, "SUCCESS") {
			success++
		}
	}
	days := time.Now().Day()
	if days < 1 {
		days = 1
	}
	dailyAvg = totalAbs / float64(days)
	rate := float64(success) / float64(monthCount) * 100
	successRate = fmt.Sprintf("%.2f", rate)
	return monthCount, income, expense, dailyAvg, successRate, typeMap
}

// PickCommonLoginIP 从最近登录中取出现次数最多的 IP（对齐 Java commonLoginIp）
func PickCommonLoginIP(logs []walletApplyLoginRow) (commonIP, commonArea, lastLogin string) {
	if len(logs) == 0 {
		return "", "", ""
	}
	lastLogin = FormatFbTimeVal(logs[0].LoginTime)
	counts := make(map[string]int64)
	for _, l := range logs {
		if l.LoginIP != "" {
			counts[l.LoginIP]++
		}
	}
	var maxCnt int64
	for ip, c := range counts {
		if c > maxCnt {
			maxCnt = c
			commonIP = ip
		}
	}
	// Java commonLoginArea 同样按 IP 聚合，此处保持一致
	commonArea = commonIP
	return commonIP, commonArea, lastLogin
}

// defaultCurrenciesForAccountType 账户类型默认币种（对齐 Java AccountType.getDefaultCurrencies）
func defaultCurrenciesForAccountType(accountType string) []string {
	switch strings.ToLower(strings.TrimSpace(accountType)) {
	case "stock_cn":
		return []string{"CNY"}
	case "stock_hk":
		return []string{"HKD"}
	case "main", "stock_us", "future", "fund", "forex":
		return []string{"USD"}
	default:
		return []string{"USD"}
	}
}

// ensureWalletTx 钱包不存在时创建（幂等）
func ensureWalletTx(tx *gorm.DB, userID int64, accountType, currency string) error {
	var cnt int64
	if err := tx.Raw(`
		SELECT COUNT(*) FROM fb_user_wallets
		WHERE user_id = ? AND account_type = ? AND currency = ?`,
		userID, accountType, currency).Scan(&cnt).Error; err != nil {
		return errx.GORMErr(err)
	}
	if cnt > 0 {
		return nil
	}
	_, err := createWalletTx(tx, userID, accountType, currency)
	return err
}

// VerifyWalletApplication 钱包申请审核（对齐 Java updateVerify）
func (d *FbMemberDal) VerifyWalletApplication(ctx context.Context, id int64, state, remark string, auditUserID int64) error {
	state = strings.ToUpper(strings.TrimSpace(state))
	remark = strings.TrimSpace(remark)
	if state == "" || remark == "" {
		return errx.BizErr("参数不完整")
	}
	if len(remark) < 5 {
		return errx.BizErr("审核意见至少5个字符")
	}
	approved := state == VerifyStatusApproved
	rejected := state == VerifyStatusRejected
	if !approved && !rejected {
		return errx.BizErr("申请状态不正确")
	}
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var app walletApplyAppRow
		err := tx.Raw(`
			SELECT id, user_id, account_type, status,
				COALESCE(risk_assessment_score, 0) AS risk_assessment_score,
				reject_reason, apply_time, audit_time, remark
			FROM fb_account_application WHERE id = ? FOR UPDATE`, id).Scan(&app).Error
		if err != nil {
			return errx.GORMErr(err)
		}
		if app.ID == 0 {
			return errx.BizErr("申请记录不存在")
		}
		if !strings.EqualFold(strings.TrimSpace(app.Status), VerifyStatusPending) {
			return errx.BizErr("申请状态不正确")
		}
		now := time.Now()
		if approved {
			accountType := strings.ToLower(strings.TrimSpace(app.AccountType))
			// 子账户开通前先补建主账户 USD 钱包
			if accountType != "" && accountType != "main" {
				if err := ensureWalletTx(tx, app.UserID, "main", "USD"); err != nil {
					return err
				}
			}
			for _, currency := range defaultCurrenciesForAccountType(app.AccountType) {
				if err := ensureWalletTx(tx, app.UserID, app.AccountType, currency); err != nil {
					return err
				}
			}
			if err := tx.Exec(`
				UPDATE fb_account_application
				SET status = ?, state = ?, reject_reason = ?,
					audit_time = ?, audit_user_id = ?, updated_at = ?
				WHERE id = ?`,
				VerifyStatusApproved, VerifyStatusApproved, remark,
				now, auditUserID, now, id).Error; err != nil {
				return errx.GORMErr(err)
			}
			return nil
		}
		if err := tx.Exec(`
			UPDATE fb_account_application
			SET status = ?, state = ?, reject_reason = ?,
				audit_time = ?, audit_user_id = ?, updated_at = ?
			WHERE id = ?`,
			VerifyStatusRejected, VerifyStatusRejected, remark,
			now, auditUserID, now, id).Error; err != nil {
			return errx.GORMErr(err)
		}
		return nil
	})
}

// ParseWalletApplyID 解析申请主键
func ParseWalletApplyID(idStr string) (int64, error) {
	id, err := strconv.ParseInt(strings.TrimSpace(idStr), 10, 64)
	if err != nil || id <= 0 {
		return 0, errx.BizErr("申请记录不存在")
	}
	return id, nil
}
