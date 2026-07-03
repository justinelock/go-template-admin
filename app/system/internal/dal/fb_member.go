package dal

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
	"ovra/toolkit/utils"

	"gorm.io/gorm"
)

// FbMemberDal 业务用户域查询（fb_users 及关联表）
type FbMemberDal struct {
	db *gorm.DB
}

func NewFbMemberDal(db *gorm.DB) *FbMemberDal {
	return &FbMemberDal{db: db}
}

// MemberListFilter 用户管理列表通用筛选
type MemberListFilter struct {
	Keyword    string
	AuthStatus string
	Deleted    string
	BeginTime  string
	EndTime    string
	Level      string
	Status     string
	PageNum    int64
	PageSize   int64
}

type memberUserRow struct {
	ID                   int64
	Username             string
	RealName             string
	IDCard               string
	AgentLevel           int32
	InviteCode           string
	CommissionRate       float64
	TotalCommission      float64
	Status               string
	IsOnline             string
	LastLogin            *time.Time
	CreatedAt            time.Time
	TotalBalance         float64
	FundPositionAmount   float64
	FundPositionDividend float64
}

// PageUsers 分页查询业务用户列表（含 USD 钱包与投信持仓聚合）
func (d *FbMemberDal) PageUsers(ctx context.Context, f MemberListFilter) (rows []memberUserRow, total int64, err error) {
	where, args := d.userWhere(f)
	base := `
		FROM fb_users u
		LEFT JOIN (
		  SELECT user_id, SUM(balance) AS total_balance
		  FROM fb_user_wallets WHERE currency = 'USD' AND balance > 0
		  GROUP BY user_id
		) w ON w.user_id = u.id
		LEFT JOIN (
		  SELECT fp.user_id,
			COALESCE(SUM(fp.amount), 0) AS position_amount,
			COALESCE(SUM(COALESCE(pl.profit_sum, 0)), 0) AS position_dividend
		  FROM fb_fund_position fp
		  LEFT JOIN (
			SELECT position_id, SUM(profit_amount) AS profit_sum
			FROM fb_fund_profit_log WHERE status = 1 GROUP BY position_id
		  ) pl ON pl.position_id = fp.id
		  WHERE fp.state = 'PENDING' AND fp.status = 1
		  GROUP BY fp.user_id
		) p ON p.user_id = u.id
		WHERE ` + where

	countSQL := "SELECT COUNT(*) " + base
	if err = d.db.WithContext(ctx).Raw(countSQL, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}

	offset := (f.PageNum - 1) * f.PageSize
	if offset < 0 {
		offset = 0
	}
	if f.PageSize <= 0 {
		f.PageSize = 10
	}
	// 不 SELECT password / pay_password
	listSQL := `SELECT u.id, u.username, u.real_name, u.id_card, u.agent_level, u.invite_code,
		  u.commission_rate, u.total_commission, u.status, u.is_online, u.last_login, u.created_at,
		  COALESCE(w.total_balance, 0) AS total_balance,
		  COALESCE(p.position_amount, 0) AS fund_position_amount,
		  COALESCE(p.position_dividend, 0) AS fund_position_dividend ` + base +
		" ORDER BY u.created_at DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), f.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

type memberKycRow struct {
	ID           int64
	UserID       int64
	Username     string
	Mobile       string
	RealName     string
	IDCardNo     string
	IDCardFront  string
	IDCardBack   string
	Status       string
	RejectReason string
	VerifiedAt   *time.Time
	CreatedAt    time.Time
	UpdatedAt    *time.Time
}

// KycPageQuery 实名认证列表筛选（对齐 Java selectPageWithUser）
type KycPageQuery struct {
	Keyword    string
	AuthStatus string
	IdCardNo   string
	Username   string
	RealName   string
	BeginTime  string
	EndTime    string
	PageNum    int64
	PageSize   int64
}

// PageKyc 实名认证分页：fb_identity_verify LEFT JOIN fb_users
func (d *FbMemberDal) PageKyc(ctx context.Context, q KycPageQuery) (rows []memberKycRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if idCard := strings.TrimSpace(q.IdCardNo); idCard != "" {
		where = append(where, "v.id_card_no = ?")
		args = append(args, idCard)
	}
	if st := strings.TrimSpace(q.AuthStatus); st != "" {
		where = append(where, "v.status = ?")
		args = append(args, st)
	}
	// 提交时间：起止同时存在时用 BETWEEN
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "v.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, `(
			u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR v.id_card_no LIKE ?
		)`)
		like := "%" + kw + "%"
		args = append(args, like, like, like, like)
	}
	if un := strings.TrimSpace(q.Username); un != "" {
		where = append(where, "u.username LIKE ?")
		args = append(args, "%"+un+"%")
	}
	if rn := strings.TrimSpace(q.RealName); rn != "" {
		where = append(where, "v.real_name LIKE ?")
		args = append(args, "%"+rn+"%")
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_identity_verify v LEFT JOIN fb_users u ON u.id = v.user_id WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT v.id, v.user_id, v.id_card_no, v.id_card_front, v.id_card_back,
		v.status, v.reject_reason, v.verified_at, v.created_at, v.updated_at,
		u.username, u.mobile, u.real_name AS real_name ` + base + " ORDER BY v.created_at DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

// VerifyKyc 实名认证审核（仅 PENDING 可审；对齐 Java updateVerify）
func (d *FbMemberDal) VerifyKyc(ctx context.Context, id int64, state, remark string) error {
	state = strings.ToUpper(strings.TrimSpace(state))
	if state == "" {
		return errx.BizErr("审核状态不能为空")
	}
	passed := state == VerifyStatusVerified || state == VerifyStatusApproved
	rejected := state == VerifyStatusRejected
	if !passed && !rejected {
		return errx.BizErr("认证状态不正确")
	}
	if rejected && strings.TrimSpace(remark) == "" {
		return errx.BizErr("拒绝时请填写拒绝原因")
	}
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var row memberKycRow
		err := tx.Raw(`
			SELECT id, user_id, real_name, id_card_no, status
			FROM fb_identity_verify WHERE id = ? FOR UPDATE`, id).Scan(&row).Error
		if err != nil {
			return errx.GORMErr(err)
		}
		if row.ID == 0 {
			return errx.BizErr("认证记录不存在")
		}
		if !strings.EqualFold(strings.TrimSpace(row.Status), VerifyStatusPending) {
			return errx.BizErr("认证状态不正确")
		}
		now := time.Now()
		if passed {
			if err := tx.Exec(`
				UPDATE fb_identity_verify
				SET status = ?, reject_reason = NULL, verified_at = ?, updated_at = ?
				WHERE id = ?`,
				VerifyStatusVerified, now, now, id).Error; err != nil {
				return errx.GORMErr(err)
			}
			// 同步用户实名信息
			if err := tx.Exec(`
				UPDATE fb_users
				SET verified = 1, verification_status = ?, real_name = ?, id_card = ?, updated_at = ?
				WHERE id = ? AND flag = 0`,
				VerifyStatusVerified, row.RealName, row.IDCardNo, now, row.UserID).Error; err != nil {
				return errx.GORMErr(err)
			}
			return nil
		}
		if err := tx.Exec(`
			UPDATE fb_identity_verify
			SET status = ?, reject_reason = ?, verified_at = ?, updated_at = ?
			WHERE id = ?`,
			VerifyStatusRejected, strings.TrimSpace(remark), now, now, id).Error; err != nil {
			return errx.GORMErr(err)
		}
		if err := tx.Exec(`
			UPDATE fb_users
			SET verification_status = ?, updated_at = ?
			WHERE id = ? AND flag = 0`,
			VerifyStatusRejected, now, row.UserID).Error; err != nil {
			return errx.GORMErr(err)
		}
		return nil
	})
}

type memberWalletRow struct {
	ID           int64
	UserID       int64
	Username     string
	Mobile       string
	RealName     string
	AccountType  string
	Balance      float64
	FrozenAmount float64
	Frozen       bool
	Version      int64
	Currency     string
	DrawTicket   int32
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// WalletPageQuery 钱包列表筛选（对齐 Java selectPageWithUser）
type WalletPageQuery struct {
	Keyword      string
	UserId       string
	AccountType  string
	Status       string
	Verified     string
	Username     string
	Mobile       string
	RealName     string
	Currency     string
	FrozenStatus string
	BeginTime    string
	EndTime      string
	PageNum      int64
	PageSize     int64
}

// PageWallets 钱包分页（SQL 对齐 Java FbUserWalletsDao.selectPageWithUser）
func (d *FbMemberDal) PageWallets(ctx context.Context, q WalletPageQuery) (rows []memberWalletRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if q.UserId != "" {
		where = append(where, "w.user_id = ?")
		args = append(args, q.UserId)
	}
	if q.Status != "" {
		where = append(where, "u.status = ?")
		args = append(args, q.Status)
	}
	if q.Verified != "" {
		where = append(where, "u.verified = ?")
		args = append(args, q.Verified)
	}
	if q.AccountType != "" {
		where = append(where, "w.account_type = ?")
		args = append(args, q.AccountType)
	}
	// Java：startTime/endTime 同时存在时用 BETWEEN
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "w.created_at BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if q.Keyword != "" {
		where = append(where, "(u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ?)")
		kw := "%" + q.Keyword + "%"
		args = append(args, kw, kw, kw)
	}
	if q.Username != "" {
		where = append(where, "u.username LIKE ?")
		args = append(args, "%"+q.Username+"%")
	}
	if q.Mobile != "" {
		where = append(where, "u.mobile LIKE ?")
		args = append(args, "%"+q.Mobile+"%")
	}
	if q.RealName != "" {
		where = append(where, "u.real_name LIKE ?")
		args = append(args, "%"+q.RealName+"%")
	}
	// 以下为 Go 钱包管理页扩展筛选（Java selectPageWithUser 无此项）
	if q.Currency != "" {
		where = append(where, "w.currency = ?")
		args = append(args, q.Currency)
	}
	if q.FrozenStatus != "" {
		where = append(where, "w.frozen = ?")
		args = append(args, q.FrozenStatus == "1" || q.FrozenStatus == "true")
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_user_wallets w LEFT JOIN fb_users u ON u.id = w.user_id WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT w.id, w.user_id, u.username, u.mobile, u.real_name, w.account_type,
  		w.balance, w.frozen_amount, w.frozen, w.version, w.currency, w.draw_ticket, w.created_at, w.updated_at ` +
		base + " ORDER BY w.created_at DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

type memberTeamRow struct {
	ID               int64
	Username         string
	RealName         string
	Level            int32
	Status           string
	TeamSize         int32
	AgentLevel       int32
	Balance          float64
	TotalTeamBalance float64
	CreatedAt        time.Time
	ParentID         int64
	ParentUsername   string
	ParentRealName   string
	Level1Members    int64
	WalletCount      int64
}

// PageTeams 团队列表分页
func (d *FbMemberDal) PageTeams(ctx context.Context, f MemberListFilter) (rows []memberTeamRow, total int64, err error) {
	where, args := d.userWhere(f)
	if f.Status != "" {
		where += " AND u.status = ?"
		args = append(args, f.Status)
	}
	base := `
		FROM fb_users u
		LEFT JOIN fb_users p ON p.id = u.parent_id
		LEFT JOIN (SELECT user_id, SUM(balance) AS bal FROM fb_user_wallets GROUP BY user_id) w ON w.user_id = u.id
		LEFT JOIN (SELECT parent_id, COUNT(*) AS cnt FROM fb_users WHERE flag = 0 AND parent_id IS NOT NULL GROUP BY parent_id) c1 ON c1.parent_id = u.id
		LEFT JOIN (SELECT user_id, COUNT(*) AS cnt FROM fb_user_wallets GROUP BY user_id) wc ON wc.user_id = u.id
		WHERE ` + where

	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (f.PageNum - 1) * f.PageSize
	listSQL := `SELECT u.id, u.username, u.real_name, u.level, u.status, u.team_size, u.agent_level,
		  COALESCE(w.bal, 0) AS balance, 0 AS total_team_balance, u.created_at,
		  COALESCE(u.parent_id, 0) AS parent_id, COALESCE(p.username, '') AS parent_username, COALESCE(p.real_name, '') AS parent_real_name,
		  COALESCE(c1.cnt, 0) AS level1_members, COALESCE(wc.cnt, 0) AS wallet_count ` +
		base + " ORDER BY u.created_at DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), f.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

type memberLoginLogRow struct {
	ID            int64
	UserID        int64
	Username      string
	RealName      string
	DeviceID      string
	LoginTime     time.Time
	LoginIP       string
	LoginLocation string
	LoginType     string
	LoginResult   string
	FailReason    string
	RiskLevel     string
	RiskDetail    string
}

// PageLoginLogs 登录记录分页
func (d *FbMemberDal) PageLoginLogs(ctx context.Context, f MemberListFilter, loginResult, loginMethod, riskLevel string) (rows []memberLoginLogRow, total int64, err error) {
	where := []string{"1=1"}
	var args []any
	if f.Keyword != "" {
		where = append(where, "(u.username LIKE ? OR u.real_name LIKE ? OR l.device_id LIKE ? OR l.login_ip LIKE ?)")
		kw := "%" + f.Keyword + "%"
		args = append(args, kw, kw, kw, kw)
	}
	if loginResult != "" {
		where = append(where, "l.login_result = ?")
		args = append(args, loginResult)
	}
	if loginMethod != "" {
		where = append(where, "l.login_type = ?")
		args = append(args, loginMethod)
	}
	if riskLevel != "" {
		where = append(where, "l.risk_level = ?")
		args = append(args, riskLevel)
	}
	if f.BeginTime != "" {
		where = append(where, "l.login_time >= ?")
		args = append(args, f.BeginTime)
	}
	if f.EndTime != "" {
		where = append(where, "l.login_time <= ?")
		args = append(args, f.EndTime)
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_device_login_log l LEFT JOIN fb_users u ON u.id = l.user_id WHERE ` + w
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	offset := (f.PageNum - 1) * f.PageSize
	listSQL := `SELECT l.id, l.user_id, u.username, u.real_name, l.device_id, l.login_time,
  		l.login_ip, l.login_location, l.login_type, l.login_result, l.fail_reason, l.risk_level, l.risk_detail ` +
		base + " ORDER BY l.login_time DESC LIMIT ? OFFSET ?"
	listArgs := append(append([]any{}, args...), f.PageSize, offset)
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rows, total, nil
}

func (d *FbMemberDal) userWhere(f MemberListFilter) (string, []any) {
	where := []string{"1=1"}
	var args []any
	if f.Deleted == "1" {
		where = append(where, "u.flag = 1")
	} else {
		where = append(where, "u.flag = 0")
	}
	// keyword 精确匹配（对齐 Java FbUsersServiceImpl.getWrapper）
	if f.Keyword != "" {
		where = append(where, "(u.username = ? OR u.mobile = ? OR u.real_name = ? OR u.id_card = ? OR CAST(u.id AS CHAR) = ?)")
		kw := f.Keyword
		args = append(args, kw, kw, kw, kw, kw)
	}
	if f.AuthStatus != "" {
		where = append(where, "u.verification_status = ?")
		args = append(args, f.AuthStatus)
	}
	if f.BeginTime != "" {
		where = append(where, "u.created_at >= ?")
		args = append(args, f.BeginTime)
	}
	if f.EndTime != "" {
		where = append(where, "u.created_at <= ?")
		args = append(args, f.EndTime)
	}
	return strings.Join(where, " AND "), args
}

// FormatFbTime 格式化可空时间供 API 返回
func FormatFbTime(t *time.Time) string {
	if t == nil || t.IsZero() {
		return ""
	}
	return t.Format("2006-01-02 15:04:05")
}

func FormatFbTimeVal(t time.Time) string {
	if t.IsZero() {
		return ""
	}
	return t.Format("2006-01-02 15:04:05")
}

func IDStr(id int64) string {
	return fmt.Sprintf("%d", id)
}

// SoftDeleteUsers 逻辑删除：fb_users.flag=1（仅未删用户）
func (d *FbMemberDal) SoftDeleteUsers(ctx context.Context, ids []string) error {
	if d == nil || d.db == nil || len(ids) == 0 {
		return nil
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id IN ?", ids).
		Where("flag = 0").
		Updates(map[string]any{
			"flag":       1,
			"updated_at": now,
		})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// ResetUserPassword 重置登录/交易密码；明文入参，MD5 后写入 fb_users
func (d *FbMemberDal) ResetUserPassword(ctx context.Context, id, plainPwd string, pwdType int64) error {
	if id == "" {
		return errx.BizErr("用户ID不能为空")
	}
	if pwdType == 0 {
		pwdType = 1
	}
	if plainPwd == "" {
		plainPwd = "123456"
	}
	if len(plainPwd) < 5 || len(plainPwd) > 20 {
		return errx.BizErr("密码长度为5 - 20")
	}
	updates := map[string]any{"updated_at": time.Now()}
	switch pwdType {
	case 1:
		updates["password"] = md5Hex(plainPwd)
	case 2:
		updates["pay_password"] = md5Hex(plainPwd)
	default:
		return errx.BizErr("密码类型无效")
	}
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id = ?", id).
		Where("flag = 0").
		Updates(updates)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("用户不存在或已删除")
	}
	return nil
}

// RestoreUsers 恢复已删用户：fb_users.flag=0（仅 flag=1）
func (d *FbMemberDal) RestoreUsers(ctx context.Context, ids []string) error {
	if d == nil || d.db == nil || len(ids) == 0 {
		return nil
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id IN ?", ids).
		Where("flag = 1").
		Updates(map[string]any{
			"flag":       0,
			"updated_at": now,
		})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("用户不存在或未被删除")
	}
	return nil
}

func md5Hex(s string) string {
	return utils.Md5(s)
}

// MemberUserInfoRow 用户详情查询行（GET /member/user/:id）
type MemberUserInfoRow struct {
	ID                     int64
	Username               string
	Email                  string
	Mobile                 string
	Phone                  string
	RealName               string
	IDCard                 string
	VerificationStatus     string
	Verified               bool
	CreditScore            int32
	SecurityQuestion       string
	SecurityAnswer         string
	Role                   string
	AccountLocked          bool
	FailedAttempts         int32
	LastLogin              *time.Time
	ParentID               int64
	ParentUsername         string
	ParentRealName         string
	Level                  int32
	AgentLevel             int32
	InviteCode             string
	CommissionRate         float64
	TotalCommission        float64
	TeamSize               int32
	Status                 string
	ContractControl        int32
	IsOnline               string
	Remark                 string
	Flag                   int32
	IsTest                 bool
	HasPassword            bool
	HasPayPassword         bool
	PayPasswordUpdatedAt   *time.Time
	PayPasswordErrorCount  int32
	PayPasswordLockedUntil *time.Time
	Avatar                 string
	TotalBalance           float64
	FundPositionAmount     float64
	FundPositionDividend   float64
	CreatedAt              time.Time
	UpdatedAt              *time.Time
}

// GetUserInfo 按主键查用户完整详情（含上级、钱包/投信聚合；不 SELECT password/pay_password）
func (d *FbMemberDal) GetUserInfo(ctx context.Context, id string) (*MemberUserInfoRow, error) {
	if id == "" {
		return nil, errx.BizErr("用户ID不能为空")
	}
	const infoSQL = `
		SELECT u.id, u.username, u.email, u.mobile, u.phone, u.real_name, u.id_card,
		  u.verification_status, u.verified, u.credit_score,
		  u.security_question, u.security_answer, u.role, u.account_locked, u.failed_attempts,
		  u.last_login, u.parent_id, pu.username AS parent_username, pu.real_name AS parent_real_name,
		  u.level, u.agent_level, u.invite_code, u.commission_rate, u.total_commission, u.team_size,
		  u.status, u.contract_control, u.is_online, u.remark, u.flag, u.is_test,
		  (u.password IS NOT NULL AND u.password != '') AS has_password,
		  (u.pay_password IS NOT NULL AND u.pay_password != '') AS has_pay_password,
		  u.pay_password_updated_at, u.pay_password_error_count, u.pay_password_locked_until,
		  u.avatar, u.created_at, u.updated_at,
		  COALESCE(w.total_balance, 0) AS total_balance,
		  COALESCE(p.position_amount, 0) AS fund_position_amount,
		  COALESCE(p.position_dividend, 0) AS fund_position_dividend
		FROM fb_users u
		LEFT JOIN fb_users pu ON pu.id = u.parent_id
		LEFT JOIN (
		  SELECT user_id, SUM(balance) AS total_balance
		  FROM fb_user_wallets WHERE currency = 'USD' AND balance > 0
		  GROUP BY user_id
		) w ON w.user_id = u.id
		LEFT JOIN (
		  SELECT fp.user_id,
			COALESCE(SUM(fp.amount), 0) AS position_amount,
			COALESCE(SUM(COALESCE(pl.profit_sum, 0)), 0) AS position_dividend
		  FROM fb_fund_position fp
		  LEFT JOIN (
			SELECT position_id, SUM(profit_amount) AS profit_sum
			FROM fb_fund_profit_log WHERE status = 1 GROUP BY position_id
		  ) pl ON pl.position_id = fp.id
		  WHERE fp.state = 'PENDING' AND fp.status = 1
		  GROUP BY fp.user_id
		) p ON p.user_id = u.id
		WHERE u.id = ? AND u.flag = 0`
	var row MemberUserInfoRow
	if err := d.db.WithContext(ctx).Raw(infoSQL, id).Scan(&row).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("用户不存在或已删除")
	}
	return &row, nil
}

// MemberUserUpdate 编辑保存字段（对齐管理端用户编辑表单）
type MemberUserUpdate struct {
	Username           string
	Password           string
	PayPassword        string
	RealName           string
	Mobile             string
	Email              string
	IDCard             string
	SecurityQuestion   string
	SecurityAnswer     string
	ParentID           string
	InviteCode         string
	CommissionRate     float64
	TotalCommission    float64
	CreditScore        int64
	VerificationStatus string
	AccountLocked      bool
	Status             string
	Verified           bool
	ContractControl    int64
	Remark             string
	Avatar             string
}

// memberUserUniqueFields 判重时读取当前用户名与身份证号
type memberUserUniqueFields struct {
	Username string
	IDCard   string
}

// GetUserUniqueFields 按 id 读取用户名、身份证号（编辑判重用）
func (d *FbMemberDal) GetUserUniqueFields(ctx context.Context, id string) (*memberUserUniqueFields, error) {
	if id == "" {
		return nil, errx.BizErr("用户ID不能为空")
	}
	var cnt int64
	if err := d.db.WithContext(ctx).Table("fb_users").
		Where("id = ?", id).Where("flag = 0").
		Count(&cnt).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	if cnt == 0 {
		return nil, errx.BizErr("用户不存在或已删除")
	}
	var row memberUserUniqueFields
	if err := d.db.WithContext(ctx).Table("fb_users").
		Select("username", "id_card").
		Where("id = ?", id).
		Where("flag = 0").
		Scan(&row).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// ExistsUsernameExcept 除指定用户外是否已有相同用户名
func (d *FbMemberDal) ExistsUsernameExcept(ctx context.Context, userID, username string) (bool, error) {
	username = strings.TrimSpace(username)
	if username == "" {
		return false, nil
	}
	var count int64
	err := d.db.WithContext(ctx).Table("fb_users").
		Where("username = ?", username).
		Where("id != ?", userID).
		Count(&count).Error
	if err != nil {
		return false, errx.GORMErr(err)
	}
	return count > 0, nil
}

// ExistsIDCardExcept 除指定用户外是否已有相同身份证号
func (d *FbMemberDal) ExistsIDCardExcept(ctx context.Context, userID, idCard string) (bool, error) {
	idCard = strings.TrimSpace(idCard)
	if idCard == "" {
		return false, nil
	}
	var count int64
	err := d.db.WithContext(ctx).Table("fb_users").
		Where("id_card = ?", idCard).
		Where("id != ?", userID).
		Count(&count).Error
	if err != nil {
		return false, errx.GORMErr(err)
	}
	return count > 0, nil
}

// UpdateUser 更新用户编辑表单字段；密码非空时 MD5 入库
func (d *FbMemberDal) UpdateUser(ctx context.Context, id string, upd MemberUserUpdate) error {
	if id == "" {
		return errx.BizErr("用户ID不能为空")
	}
	if strings.TrimSpace(upd.Username) == "" {
		return errx.BizErr("用户名不能为空")
	}
	if strings.TrimSpace(upd.RealName) == "" {
		return errx.BizErr("真实姓名不能为空")
	}
	if strings.TrimSpace(upd.IDCard) == "" {
		return errx.BizErr("身份证号不能为空")
	}
	if upd.Status == "" {
		return errx.BizErr("用户状态不能为空")
	}
	if upd.ContractControl != 0 && upd.ContractControl != 1 && upd.ContractControl != 2 && upd.ContractControl != 3 {
		return errx.BizErr("合约控制取值无效")
	}
	contractControl := upd.ContractControl
	if contractControl == 0 {
		contractControl = 3
	}
	// 用户名/身份证号变更时判重（对齐 uk_username、id_id_card）
	current, err := d.GetUserUniqueFields(ctx, id)
	if err != nil {
		return err
	}
	username := strings.TrimSpace(upd.Username)
	idCard := strings.TrimSpace(upd.IDCard)
	if username != strings.TrimSpace(current.Username) {
		exists, err := d.ExistsUsernameExcept(ctx, id, username)
		if err != nil {
			return err
		}
		if exists {
			return errx.BizErr("用户名已经存在")
		}
	}
	if idCard != strings.TrimSpace(current.IDCard) {
		exists, err := d.ExistsIDCardExcept(ctx, id, idCard)
		if err != nil {
			return err
		}
		if exists {
			return errx.BizErr("身份证号已经存在")
		}
	}
	updates := map[string]any{
		"updated_at":          time.Now(),
		"username":            username,
		"real_name":           upd.RealName,
		"mobile":              upd.Mobile,
		"email":               upd.Email,
		"id_card":             idCard,
		"security_question":   upd.SecurityQuestion,
		"security_answer":     upd.SecurityAnswer,
		"invite_code":         upd.InviteCode,
		"commission_rate":     upd.CommissionRate,
		"total_commission":    upd.TotalCommission,
		"credit_score":        upd.CreditScore,
		"verification_status": upd.VerificationStatus,
		"account_locked":      upd.AccountLocked,
		"status":              upd.Status,
		"verified":            upd.Verified,
		"contract_control":    contractControl,
		"remark":              upd.Remark,
	}
	// 头像 base64：非空时更新（裁剪后为 data URL 或纯 base64 原样入库）
	if av := strings.TrimSpace(upd.Avatar); av != "" {
		updates["avatar"] = av
	}
	// 上级代理：空字符串表示清空
	if upd.ParentID == "" {
		updates["parent_id"] = nil
	} else {
		updates["parent_id"] = upd.ParentID
	}
	if pwd := strings.TrimSpace(upd.Password); pwd != "" {
		updates["password"] = md5Hex(pwd)
	}
	if payPwd := strings.TrimSpace(upd.PayPassword); payPwd != "" {
		updates["pay_password"] = md5Hex(payPwd)
	}
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id = ?", id).
		Where("flag = 0").
		Updates(updates)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("用户不存在或已删除")
	}
	return nil
}
