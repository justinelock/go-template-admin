package dal

// 产品配置 DAL：fb_fund_product 分页、详情、增删改（对齐 Java FbFundProductServiceImpl）

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
)

// FundProductPageQuery 产品配置列表筛选
type FundProductPageQuery struct {
	Keyword    string
	Code       string
	Name       string
	Type       string
	Status     string
	BeginTime  string
	EndTime    string
	OrderField string
	Order      string
	PageNum    int64
	PageSize   int64
}

type fundProductListRow struct {
	ID                int64
	Code              string
	Alias             string
	TradePair         string
	Name              string
	Type              string
	Market            string
	TradingHours      string
	Description       string
	Status            int
	DividendRatio     float64
	Currency          string
	Period            int
	TotalDividendRate float64
	DailyDividendRate float64
	DividendEndDate   *time.Time
	DividendStrDate   *time.Time
	IsLocked          int
	LimitBuyCount     int
	LimitSellDays     int
	LimitBuyAmount    int
	Sort              int
	Odds              float64
	CreateTime        time.Time
	UpdateTime        time.Time
}

// FundProductVO 产品配置对外结构
type FundProductVO struct {
	ID                int64
	Code              string
	Alias             string
	TradePair         string
	Name              string
	Type              string
	Market            string
	TradingHours      string
	Description       string
	Status            int
	DividendRatio     float64
	Currency          string
	Period            int
	TotalDividendRate float64
	DailyDividendRate float64
	DividendEndDate   *time.Time
	DividendStrDate   *time.Time
	IsLocked          int
	LimitBuyCount     int
	LimitSellDays     int
	LimitBuyAmount    int
	Sort              int
	Odds              float64
	CreateTime        time.Time
	UpdateTime        time.Time
}

// FundProductSaveInput 新增/修改写入字段
type FundProductSaveInput struct {
	ID           int64
	Code         string
	Alias        string
	TradePair    string
	Name         string
	Type         string
	Market       string
	TradingHours string
	Description  string
	Status       int
	Currency     string
	Odds         float64
	Sort         int
}

// PageFundProducts 分页查 fb_fund_product
func (d *FbMemberDal) PageFundProducts(ctx context.Context, q FundProductPageQuery) ([]FundProductVO, int64, error) {
	where := []string{"1=1"}
	var args []any

	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, "(p.code LIKE ? OR p.name LIKE ?)")
		p := "%" + kw + "%"
		args = append(args, p, p)
	}
	if code := strings.TrimSpace(q.Code); code != "" {
		where = append(where, "p.code LIKE ?")
		args = append(args, "%"+code+"%")
	}
	if name := strings.TrimSpace(q.Name); name != "" {
		where = append(where, "p.name LIKE ?")
		args = append(args, "%"+name+"%")
	}
	if typ := strings.TrimSpace(q.Type); typ != "" {
		where = append(where, "p.type = ?")
		args = append(args, typ)
	}
	if st := strings.TrimSpace(q.Status); st != "" {
		where = append(where, "p.status = ?")
		args = append(args, st)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "p.create_time BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}

	w := strings.Join(where, " AND ")
	base := `FROM fb_fund_product p WHERE ` + w

	var total int64
	if err := d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if total == 0 {
		return []FundProductVO{}, 0, nil
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize

	orderSQL := buildFundProductOrderSQL(q.OrderField, q.Order)
	var raw []fundProductListRow
	listSQL := `SELECT p.id, p.code, COALESCE(p.alias,'') AS alias,
		COALESCE(p.trade_pair,'') AS trade_pair, COALESCE(p.name,'') AS name,
		COALESCE(p.type,'') AS type, COALESCE(p.market,'') AS market,
		COALESCE(p.trading_hours,'') AS trading_hours, COALESCE(p.description,'') AS description,
		COALESCE(p.status,1) AS status, COALESCE(p.dividend_ratio,0) AS dividend_ratio,
		COALESCE(p.currency,'') AS currency, COALESCE(p.period,0) AS period,
		COALESCE(p.total_dividend_rate,0) AS total_dividend_rate,
		COALESCE(p.daily_dividend_rate,0) AS daily_dividend_rate,
		p.dividend_end_date, p.dividend_str_date,
		COALESCE(p.is_locked,0) AS is_locked, COALESCE(p.limit_buy_count,0) AS limit_buy_count,
		COALESCE(p.limit_sell_days,0) AS limit_sell_days, COALESCE(p.limit_buy_amount,0) AS limit_buy_amount,
		COALESCE(p.sort,0) AS sort, COALESCE(p.odds,0) AS odds,
		p.create_time, p.update_time ` + base + orderSQL + ` LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err := d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&raw).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	out := make([]FundProductVO, 0, len(raw))
	for _, r := range raw {
		out = append(out, fundProductRowToVO(r))
	}
	return out, total, nil
}

func buildFundProductOrderSQL(orderField, order string) string {
	col := "p.create_time"
	switch strings.ToLower(strings.TrimSpace(orderField)) {
	case "sort":
		col = "p.sort"
	case "code":
		col = "p.code"
	case "create_time":
		col = "p.create_time"
	}
	dir := "DESC"
	if strings.EqualFold(strings.TrimSpace(order), "asc") {
		dir = "ASC"
	}
	if col != "p.create_time" {
		return fmt.Sprintf(" ORDER BY %s %s, p.create_time DESC", col, dir)
	}
	return fmt.Sprintf(" ORDER BY %s %s", col, dir)
}

func fundProductRowToVO(r fundProductListRow) FundProductVO {
	return FundProductVO{
		ID:                r.ID,
		Code:              r.Code,
		Alias:             r.Alias,
		TradePair:         r.TradePair,
		Name:              r.Name,
		Type:              r.Type,
		Market:            r.Market,
		TradingHours:      r.TradingHours,
		Description:       r.Description,
		Status:            r.Status,
		DividendRatio:     r.DividendRatio,
		Currency:          r.Currency,
		Period:            r.Period,
		TotalDividendRate: r.TotalDividendRate,
		DailyDividendRate: r.DailyDividendRate,
		DividendEndDate:   r.DividendEndDate,
		DividendStrDate:   r.DividendStrDate,
		IsLocked:          r.IsLocked,
		LimitBuyCount:     r.LimitBuyCount,
		LimitSellDays:     r.LimitSellDays,
		LimitBuyAmount:    r.LimitBuyAmount,
		Sort:              r.Sort,
		Odds:              r.Odds,
		CreateTime:        r.CreateTime,
		UpdateTime:        r.UpdateTime,
	}
}

// GetFundProductByID 按主键查产品配置
func (d *FbMemberDal) GetFundProductByID(ctx context.Context, id int64) (*FundProductVO, error) {
	if id <= 0 {
		return nil, nil
	}
	var raw fundProductListRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT p.id, p.code, COALESCE(p.alias,'') AS alias,
			COALESCE(p.trade_pair,'') AS trade_pair, COALESCE(p.name,'') AS name,
			COALESCE(p.type,'') AS type, COALESCE(p.market,'') AS market,
			COALESCE(p.trading_hours,'') AS trading_hours, COALESCE(p.description,'') AS description,
			COALESCE(p.status,1) AS status, COALESCE(p.dividend_ratio,0) AS dividend_ratio,
			COALESCE(p.currency,'') AS currency, COALESCE(p.period,0) AS period,
			COALESCE(p.total_dividend_rate,0) AS total_dividend_rate,
			COALESCE(p.daily_dividend_rate,0) AS daily_dividend_rate,
			p.dividend_end_date, p.dividend_str_date,
			COALESCE(p.is_locked,0) AS is_locked, COALESCE(p.limit_buy_count,0) AS limit_buy_count,
			COALESCE(p.limit_sell_days,0) AS limit_sell_days, COALESCE(p.limit_buy_amount,0) AS limit_buy_amount,
			COALESCE(p.sort,0) AS sort, COALESCE(p.odds,0) AS odds,
			p.create_time, p.update_time
		FROM fb_fund_product p WHERE p.id = ?`, id).Scan(&raw).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if raw.ID == 0 {
		return nil, nil
	}
	vo := fundProductRowToVO(raw)
	return &vo, nil
}

// InsertFundProduct 新增产品配置
func (d *FbMemberDal) InsertFundProduct(ctx context.Context, in FundProductSaveInput) error {
	now := time.Now()
	desc := strings.TrimSpace(in.Description)
	if desc == "" {
		desc = strings.TrimSpace(in.Currency)
	}
	res := d.db.WithContext(ctx).Exec(`
		INSERT INTO fb_fund_product (
			id, code, alias, trade_pair, name, type, market, trading_hours, description,
			status, currency, odds, sort, create_time, update_time
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		in.ID, in.Code, in.Alias, in.TradePair, in.Name, in.Type, in.Market, in.TradingHours, desc,
		in.Status, in.Currency, in.Odds, in.Sort, now, now)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// UpdateFundProduct 按 id 更新产品配置
func (d *FbMemberDal) UpdateFundProduct(ctx context.Context, in FundProductSaveInput) error {
	if in.ID <= 0 {
		return errx.BizErr("产品ID不能为空")
	}
	now := time.Now()
	desc := strings.TrimSpace(in.Description)
	if desc == "" {
		desc = strings.TrimSpace(in.Currency)
	}
	res := d.db.WithContext(ctx).Exec(`
		UPDATE fb_fund_product SET
			alias=?, trade_pair=?, name=?, type=?, market=?, trading_hours=?, description=?,
			status=?, currency=?, odds=?, sort=?, update_time=?
		WHERE id=? AND code=?`,
		in.Alias, in.TradePair, in.Name, in.Type, in.Market, in.TradingHours, desc,
		in.Status, in.Currency, in.Odds, in.Sort, now, in.ID, in.Code)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("产品不存在或产品代码不匹配")
	}
	return nil
}

// DeleteFundProductsByIds 物理删除产品配置
func (d *FbMemberDal) DeleteFundProductsByIds(ctx context.Context, ids []int64) error {
	if len(ids) == 0 {
		return errx.BizErr("请选择要删除的产品")
	}
	ph := placeholders(len(ids))
	res := d.db.WithContext(ctx).Exec(
		`DELETE FROM fb_fund_product WHERE id IN (`+ph+`)`,
		int64SliceToAny(ids)...,
	)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// ParseFundProductID 解析产品主键
func ParseFundProductID(s string) (int64, error) {
	return parsePositiveInt64ID(s, "产品ID")
}

// NormalizeFundProductSaveInput 校验写入参数（对齐 Java 弹窗 rules）
func NormalizeFundProductSaveInput(in *FundProductSaveInput) error {
	in.Code = strings.TrimSpace(in.Code)
	in.Name = strings.TrimSpace(in.Name)
	in.Type = strings.TrimSpace(in.Type)
	in.Market = strings.TrimSpace(in.Market)
	in.Currency = strings.TrimSpace(in.Currency)
	if in.Code == "" {
		return errx.BizErr("产品代码不能为空")
	}
	if in.Name == "" {
		return errx.BizErr("产品名称不能为空")
	}
	if in.Type == "" {
		return errx.BizErr("产品类型不能为空")
	}
	if in.Market == "" {
		return errx.BizErr("市场不能为空")
	}
	if in.Currency == "" {
		return errx.BizErr("币种不能为空")
	}
	if in.Odds <= 0 {
		return errx.BizErr("赔率不能为空")
	}
	if in.Status != 0 && in.Status != 1 {
		in.Status = 1
	}
	return nil
}
