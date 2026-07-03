package dal

// 投信持仓与收益流水 DAL：fb_fund_position 列表、fb_fund_profit_log 抽屉与修改收益（对齐 Java FbFundPositionServiceImpl）

import (
	"context"
	"strings"
	"time"

	"ovra/toolkit/errx"

	"gorm.io/gorm"
)

// FundPositionPageQuery 持仓列表筛选（对齐 Java FbFundPositionServiceImpl.getWrapper）
type FundPositionPageQuery struct {
	Keyword   string
	FundCode  string
	Status    string
	BeginTime string
	EndTime   string
	PageNum   int64
	PageSize  int64
}

type fundPositionListRow struct {
	ID             int64
	UserID         int64
	FundCode       string
	Amount         float64
	BuyDate        time.Time
	StartDate      *time.Time
	EndDate        *time.Time
	Period         int
	Rate           float64
	Profit         float64
	State          string
	Status         int
	LastProfitDate *time.Time
	CreateTime     time.Time
	UpdateTime     time.Time
	Username       string
	Mobile         string
	RealName       string
	FundName       string
}

// FundPositionVO 持仓列表对外结构
type FundPositionVO struct {
	ID             int64
	UserID         int64
	Username       string
	Mobile         string
	RealName       string
	FundCode       string
	FundName       string
	Amount         float64
	BuyDate        time.Time
	StartDate      *time.Time
	EndDate        *time.Time
	Period         int
	Rate           float64
	Profit         float64
	State          string
	Status         int
	LastProfitDate *time.Time
	CreateTime     time.Time
	UpdateTime     time.Time
}

type fundMeta struct {
	Code   string
	Name   string
	Period int
	Rate   float64
}

// PageFundPositions 分页查 fb_fund_position 并 JOIN 用户、补齐基金信息
func (d *FbMemberDal) PageFundPositions(ctx context.Context, q FundPositionPageQuery) ([]FundPositionVO, int64, error) {
	where := []string{"1=1"}
	var args []any

	// status / fundCode / 创建时间区间
	if st := strings.TrimSpace(q.Status); st != "" {
		where = append(where, "p.status = ?")
		args = append(args, st)
	}
	if fc := strings.TrimSpace(q.FundCode); fc != "" {
		where = append(where, "p.fund_code = ?")
		args = append(args, fc)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "p.create_time BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	// keyword 先解析为用户 id 集合（与合约/充值列表同模式）
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		userIDs, err := d.UserIdsByKeyword(ctx, kw)
		if err != nil {
			return nil, 0, err
		}
		if len(userIDs) == 0 {
			return []FundPositionVO{}, 0, nil
		}
		where = append(where, "p.user_id IN ("+placeholders(len(userIDs))+")")
		args = append(args, int64SliceToAny(userIDs)...)
	}

	w := strings.Join(where, " AND ")
	base := `FROM fb_fund_position p
		LEFT JOIN fb_users u ON u.id = p.user_id
		WHERE ` + w

	var total int64
	if err := d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if total == 0 {
		return []FundPositionVO{}, 0, nil
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize

	var raw []fundPositionListRow
	listSQL := `SELECT p.id, p.user_id, p.fund_code, p.amount, p.buy_date, p.start_date, p.end_date,
		COALESCE(p.period, 0) AS period, COALESCE(p.rate, 0) AS rate, COALESCE(p.profit, 0) AS profit,
		COALESCE(p.state, '') AS state, COALESCE(p.status, 1) AS status,
		p.last_profit_date, p.create_time, p.update_time,
		COALESCE(u.username, '') AS username, COALESCE(u.mobile, '') AS mobile, COALESCE(u.real_name, '') AS real_name
		` + base + ` ORDER BY p.create_time DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err := d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&raw).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}

	// 批量补 fundName / period / rate（对齐 Java enrichPositionDisplay）
	rows, err := enrichFundPositionRows(ctx, d.db, raw)
	if err != nil {
		return nil, 0, err
	}
	return rows, total, nil
}

// enrichFundPositionRows 批量补 fundName，period/rate 为空时从 fb_fund 回填
func enrichFundPositionRows(ctx context.Context, db *gorm.DB, raw []fundPositionListRow) ([]FundPositionVO, error) {
	if len(raw) == 0 {
		return []FundPositionVO{}, nil
	}
	// 收集本页基金代码，一次查 fb_fund
	codeSet := make(map[string]struct{})
	for _, r := range raw {
		if c := strings.TrimSpace(r.FundCode); c != "" {
			codeSet[strings.ToUpper(c)] = struct{}{}
		}
	}
	fundMap, err := loadFundMetaByCodes(ctx, db, codeSet)
	if err != nil {
		return nil, err
	}

	out := make([]FundPositionVO, 0, len(raw))
	for _, r := range raw {
		vo := FundPositionVO{
			ID:             r.ID,
			UserID:         r.UserID,
			Username:       r.Username,
			Mobile:         r.Mobile,
			RealName:       r.RealName,
			FundCode:       r.FundCode,
			Amount:         r.Amount,
			BuyDate:        r.BuyDate,
			StartDate:      r.StartDate,
			EndDate:        r.EndDate,
			Period:         r.Period,
			Rate:           r.Rate,
			Profit:         r.Profit,
			State:          r.State,
			Status:         r.Status,
			LastProfitDate: r.LastProfitDate,
			CreateTime:     r.CreateTime,
			UpdateTime:     r.UpdateTime,
		}
		meta := fundMap[strings.ToUpper(strings.TrimSpace(r.FundCode))]
		if meta.Name != "" {
			vo.FundName = meta.Name
		}
		// period 为空时：起止日差值或基金配置
		if vo.Period <= 0 && vo.StartDate != nil && vo.EndDate != nil && !vo.StartDate.IsZero() && !vo.EndDate.IsZero() {
			days := int(vo.EndDate.Sub(*vo.StartDate).Hours() / 24)
			if days > 0 {
				vo.Period = days
			}
		}
		if vo.Period <= 0 && meta.Period > 0 {
			vo.Period = meta.Period
		}
		if vo.Rate == 0 && meta.Rate > 0 {
			vo.Rate = meta.Rate
		}
		out = append(out, vo)
	}
	return out, nil
}

// loadFundMetaByCodes 按基金代码批量查 name/period/rate，供 enrichFundPositionRows 回填
func loadFundMetaByCodes(ctx context.Context, db *gorm.DB, codes map[string]struct{}) (map[string]fundMeta, error) {
	out := make(map[string]fundMeta)
	if len(codes) == 0 {
		return out, nil
	}
	codeList := make([]string, 0, len(codes))
	for c := range codes {
		codeList = append(codeList, c)
	}
	var rows []fundMeta
	err := db.WithContext(ctx).Raw(`
		SELECT UPPER(code) AS code, COALESCE(name, '') AS name,
			COALESCE(period, 0) AS period, COALESCE(rate, 0) AS rate
		FROM fb_fund WHERE UPPER(code) IN (`+placeholders(len(codeList))+`)`,
		stringSliceToAny(codeList)...).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range rows {
		out[strings.ToUpper(r.Code)] = r
	}
	return out, nil
}

func stringSliceToAny(ss []string) []any {
	out := make([]any, len(ss))
	for i, s := range ss {
		out[i] = s
	}
	return out
}

// FundProfitLogPageQuery 收益记录筛选（fb_fund_profit_log）
type FundProfitLogPageQuery struct {
	UserID     int64
	PositionID int64
	PageNum    int64
	PageSize   int64
}

type fundProfitLogListRow struct {
	ID               int64
	UserID           int64
	PositionID       int64
	OrderID          *int64
	FundCode         string
	ProfitDate       time.Time
	ProfitDatetime   *time.Time
	ProfitAmount     float64
	CumulativeProfit float64
	Status           int
	CreateTime       *time.Time
	UpdateTime       *time.Time
}

// FundProfitLogVO 收益记录行
type FundProfitLogVO struct {
	ID               int64
	UserID           int64
	PositionID       int64
	OrderID          *int64
	FundCode         string
	ProfitDate       time.Time
	ProfitDatetime   *time.Time
	ProfitAmount     float64
	CumulativeProfit float64
	Status           int
	CreateTime       *time.Time
	UpdateTime       *time.Time
}

// PageFundProfitLogs 按 userId + positionId 分页查 fb_fund_profit_log（收益订单抽屉）
func (d *FbMemberDal) PageFundProfitLogs(ctx context.Context, q FundProfitLogPageQuery) ([]FundProfitLogVO, int64, error) {
	if q.UserID <= 0 {
		return nil, 0, errx.BizErr("用户ID不能为空")
	}
	if q.PositionID <= 0 {
		return nil, 0, errx.BizErr("持仓ID不能为空")
	}

	base := `FROM fb_fund_profit_log l WHERE l.user_id = ? AND l.position_id = ?`
	args := []any{q.UserID, q.PositionID}

	var total int64
	if err := d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize

	var raw []fundProfitLogListRow
	// 按收益日期倒序，同日按 id 倒序
	listSQL := `SELECT l.id, l.user_id, l.position_id, l.order_id, l.fund_code,
		l.profit_date, l.profit_datetime,
		COALESCE(l.profit_amount, 0) AS profit_amount,
		COALESCE(l.cumulative_profit, 0) AS cumulative_profit,
		COALESCE(l.status, 0) AS status,
		l.create_time, l.update_time ` +
		base + ` ORDER BY l.profit_date DESC, l.id DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err := d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&raw).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}

	out := make([]FundProfitLogVO, 0, len(raw))
	for _, r := range raw {
		out = append(out, FundProfitLogVO{
			ID:               r.ID,
			UserID:           r.UserID,
			PositionID:       r.PositionID,
			OrderID:          r.OrderID,
			FundCode:         r.FundCode,
			ProfitDate:       r.ProfitDate,
			ProfitDatetime:   r.ProfitDatetime,
			ProfitAmount:     r.ProfitAmount,
			CumulativeProfit: r.CumulativeProfit,
			Status:           r.Status,
			CreateTime:       r.CreateTime,
			UpdateTime:       r.UpdateTime,
		})
	}
	return out, total, nil
}

// FormatFbDateOnly 格式化为 yyyy-MM-dd
func FormatFbDateOnly(t time.Time) string {
	if t.IsZero() {
		return ""
	}
	return t.Format("2006-01-02")
}

// FormatFbDatePtr 可空日期
func FormatFbDatePtr(t *time.Time) string {
	if t == nil || t.IsZero() {
		return ""
	}
	return t.Format("2006-01-02")
}

type fundProfitLogBrief struct {
	ID           int64
	UserID       int64
	PositionID   int64
	FundCode     string
	ProfitAmount float64
}

type fundPositionBrief struct {
	ID       int64
	UserID   int64
	FundCode string
}

// GetPositionProfitForDay 查询持仓某日收益金额；无流水返回 nil（对齐 Java getProfitBefore）
func (d *FbMemberDal) GetPositionProfitForDay(ctx context.Context, positionID int64, profitDate string) (*float64, error) {
	if positionID <= 0 {
		return nil, nil
	}
	day, err := parseProfitDate(profitDate)
	if err != nil {
		return nil, err
	}
	dateStr := day.Format("2006-01-02")
	// 先判断是否存在，避免 Scan 无行与金额为 0 混淆
	var exists int64
	if err := d.db.WithContext(ctx).Raw(`
		SELECT COUNT(*) FROM fb_fund_profit_log WHERE position_id = ? AND profit_date = ?`,
		positionID, dateStr).Scan(&exists).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	if exists == 0 {
		return nil, nil
	}
	var amount float64
	if err := d.db.WithContext(ctx).Raw(`
		SELECT profit_amount FROM fb_fund_profit_log
		WHERE position_id = ? AND profit_date = ? LIMIT 1`,
		positionID, dateStr).Scan(&amount).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	return &amount, nil
}

// UpdatePositionProfit 修改持仓某日收益；有流水则 UPDATE，无流水则 INSERT（对齐 Java updateProfit）
func (d *FbMemberDal) UpdatePositionProfit(ctx context.Context, positionID int64, profitDate string, profit float64) error {
	if positionID <= 0 {
		return errx.BizErr("持仓ID不能为空")
	}
	day, err := parseProfitDate(profitDate)
	if err != nil {
		return err
	}
	if profit <= 0 {
		return errx.BizErr("修改后的收益金额必须大于 0")
	}

	// 校验持仓存在且带 fund_code
	var pos fundPositionBrief
	if err := d.db.WithContext(ctx).Raw(`
		SELECT id, user_id, fund_code FROM fb_fund_position WHERE id = ?`, positionID).Scan(&pos).Error; err != nil {
		return errx.GORMErr(err)
	}
	if pos.ID == 0 {
		return errx.BizErr("持仓不存在")
	}
	if strings.TrimSpace(pos.FundCode) == "" {
		return errx.BizErr("持仓基金代码为空，无法写入收益流水")
	}

	dateStr := day.Format("2006-01-02")
	var logRow fundProfitLogBrief
	_ = d.db.WithContext(ctx).Raw(`
		SELECT id, user_id, position_id, fund_code, profit_amount
		FROM fb_fund_profit_log WHERE position_id = ? AND profit_date = ? LIMIT 1`,
		positionID, dateStr).Scan(&logRow).Error

	now := time.Now()
	if logRow.ID > 0 {
		// 已有流水：覆盖金额并刷新计提时间
		res := d.db.WithContext(ctx).Exec(`
			UPDATE fb_fund_profit_log
			SET profit_amount = ?, profit_datetime = ?, status = 1, update_time = ?
			WHERE id = ?`, profit, now, now, logRow.ID)
		if res.Error != nil {
			return errx.GORMErr(res.Error)
		}
		return nil
	}

	// 定时任务尚未计提时插入一条有效流水
	res := d.db.WithContext(ctx).Exec(`
		INSERT INTO fb_fund_profit_log
			(user_id, position_id, fund_code, profit_date, profit_datetime, profit_amount, cumulative_profit, status, create_time, update_time)
		VALUES (?, ?, ?, ?, ?, ?, 0, 1, ?, ?)`,
		pos.UserID, positionID, pos.FundCode, dateStr, now, profit, now, now)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// parseProfitDate 解析 yyyy-MM-dd 收益日期
func parseProfitDate(s string) (time.Time, error) {
	s = strings.TrimSpace(s)
	if s == "" {
		return time.Time{}, errx.BizErr("收益日期不能为空")
	}
	t, err := time.ParseInLocation("2006-01-02", s, time.Local)
	if err != nil {
		return time.Time{}, errx.BizErr("收益日期格式无效")
	}
	return t, nil
}
