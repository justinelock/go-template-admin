package dal

// 投信产品 DAL：fb_fund 分页、详情、增删改（对齐 Java FundServiceImpl / FbFundController）

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
	"ovra/toolkit/upload"
)

const defaultMinAppendAmount = 100.0

// FundPageQuery 投信列表筛选
type FundPageQuery struct {
	Keyword    string
	Name       string
	Code       string
	Status     string
	SoldOut    string
	BeginTime  string
	EndTime    string
	OrderField string
	Order      string
	PageNum    int64
	PageSize   int64
}

type fundListRow struct {
	ID                 int64
	Code               string
	Symbol             string
	Name               string
	Company            string
	Ev                 string
	Price              float64
	Currency           string
	Description        string
	Poster             string
	Status             int
	SoldOut            int
	RateMin            float64
	RateMax            float64
	Rate               float64
	MinAmount          float64
	MinAppendAmount    float64
	MaxAmount          float64
	Period             int
	RateMode           string
	LatestAmountRaised float64
	LastestFundingDate *time.Time
	Sort               int
	CreateTime         time.Time
	UpdateTime         time.Time
}

// FundVO 投信产品对外结构
type FundVO struct {
	ID                 int64
	Code               string
	Symbol             string
	Name               string
	Company            string
	Ev                 string
	Price              float64
	Currency           string
	Description        string
	Poster             string
	Status             int
	SoldOut            int
	RateMin            float64
	RateMax            float64
	Rate               float64
	MinAmount          float64
	MinAppendAmount    float64
	MaxAmount          float64
	Period             int
	RateMode           string
	LatestAmountRaised float64
	LastestFundingDate *time.Time
	Sort               int
	CreateTime         time.Time
	UpdateTime         time.Time
}

// FundSaveInput 新增/修改写入字段
type FundSaveInput struct {
	ID                 int64
	Code               string
	Symbol             string
	Name               string
	Company            string
	Ev                 string
	Price              float64
	Currency           string
	Description        string
	Poster             *string // nil 表示不更新 poster
	Status             int
	SoldOut            int
	RateMin            float64
	RateMax            float64
	Rate               float64
	MinAmount          float64
	MinAppendAmount    float64
	MaxAmount          float64
	Period             int
	RateMode           string
	LatestAmountRaised float64
	LastestFundingDate *time.Time
	Sort               int
}

// PageFunds 分页查 fb_fund
func (d *FbMemberDal) PageFunds(ctx context.Context, q FundPageQuery) ([]FundVO, int64, error) {
	where := []string{"1=1"}
	var args []any

	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, "(f.code LIKE ? OR f.name LIKE ?)")
		p := "%" + kw + "%"
		args = append(args, p, p)
	}
	if name := strings.TrimSpace(q.Name); name != "" {
		where = append(where, "f.name LIKE ?")
		args = append(args, "%"+name+"%")
	}
	if code := strings.TrimSpace(q.Code); code != "" {
		where = append(where, "f.code LIKE ?")
		args = append(args, "%"+code+"%")
	}
	if st := strings.TrimSpace(q.Status); st != "" {
		where = append(where, "f.status = ?")
		args = append(args, st)
	}
	if so := strings.TrimSpace(q.SoldOut); so != "" {
		where = append(where, "f.sold_out = ?")
		args = append(args, so)
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "f.create_time BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}

	w := strings.Join(where, " AND ")
	base := `FROM fb_fund f WHERE ` + w

	var total int64
	if err := d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if total == 0 {
		return []FundVO{}, 0, nil
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize

	orderSQL := buildFundOrderSQL(q.OrderField, q.Order)
	var raw []fundListRow
	listSQL := `SELECT f.id, f.code, f.symbol, f.name, f.company, f.ev,
		COALESCE(f.price, 0) AS price, COALESCE(f.currency, '') AS currency,
		COALESCE(f.description, '') AS description, COALESCE(f.poster, '') AS poster,
		COALESCE(f.status, 1) AS status, COALESCE(f.sold_out, 0) AS sold_out,
		COALESCE(f.rate_min, 0) AS rate_min, COALESCE(f.rate_max, 0) AS rate_max,
		COALESCE(f.rate, 0) AS rate,
		COALESCE(f.min_amount, 0) AS min_amount, COALESCE(f.min_append_amount, 0) AS min_append_amount,
		COALESCE(f.max_amount, 0) AS max_amount, COALESCE(f.period, 0) AS period,
		COALESCE(f.rate_mode, '') AS rate_mode,
		COALESCE(f.latest_amount_raised, 0) AS latest_amount_raised,
		f.lastest_funding_date,
		COALESCE(f.sort, 0) AS sort, f.create_time, f.update_time ` +
		base + orderSQL + ` LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err := d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&raw).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return mapFundRows(raw), total, nil
}

func buildFundOrderSQL(orderField, order string) string {
	col := "f.sort"
	switch strings.ToLower(strings.TrimSpace(orderField)) {
	case "create_time":
		col = "f.create_time"
	case "code":
		col = "f.code"
	case "name":
		col = "f.name"
	case "sort":
		col = "f.sort"
	}
	dir := "DESC"
	if strings.EqualFold(strings.TrimSpace(order), "asc") {
		dir = "ASC"
	}
	// 主排序后按创建时间倒序稳定
	if col != "f.create_time" {
		return fmt.Sprintf(" ORDER BY %s %s, f.create_time DESC", col, dir)
	}
	return fmt.Sprintf(" ORDER BY %s %s", col, dir)
}

func mapFundRows(raw []fundListRow) []FundVO {
	out := make([]FundVO, 0, len(raw))
	for _, r := range raw {
		out = append(out, fundRowToVO(r))
	}
	return out
}

func fundRowToVO(r fundListRow) FundVO {
	return FundVO{
		ID:                 r.ID,
		Code:               r.Code,
		Symbol:             r.Symbol,
		Name:               r.Name,
		Company:            r.Company,
		Ev:                 r.Ev,
		Price:              r.Price,
		Currency:           r.Currency,
		Description:        r.Description,
		Poster:             r.Poster,
		Status:             r.Status,
		SoldOut:            r.SoldOut,
		RateMin:            r.RateMin,
		RateMax:            r.RateMax,
		Rate:               r.Rate,
		MinAmount:          r.MinAmount,
		MinAppendAmount:    r.MinAppendAmount,
		MaxAmount:          r.MaxAmount,
		Period:             r.Period,
		RateMode:           r.RateMode,
		LatestAmountRaised: r.LatestAmountRaised,
		LastestFundingDate: r.LastestFundingDate,
		Sort:               r.Sort,
		CreateTime:         r.CreateTime,
		UpdateTime:         r.UpdateTime,
	}
}

// GetFundByID 按主键查投信产品
func (d *FbMemberDal) GetFundByID(ctx context.Context, id int64) (*FundVO, error) {
	if id <= 0 {
		return nil, nil
	}
	var raw fundListRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT f.id, f.code, f.symbol, f.name, f.company, f.ev,
			COALESCE(f.price, 0) AS price, COALESCE(f.currency, '') AS currency,
			COALESCE(f.description, '') AS description, COALESCE(f.poster, '') AS poster,
			COALESCE(f.status, 1) AS status, COALESCE(f.sold_out, 0) AS sold_out,
			COALESCE(f.rate_min, 0) AS rate_min, COALESCE(f.rate_max, 0) AS rate_max,
			COALESCE(f.rate, 0) AS rate,
			COALESCE(f.min_amount, 0) AS min_amount, COALESCE(f.min_append_amount, 0) AS min_append_amount,
			COALESCE(f.max_amount, 0) AS max_amount, COALESCE(f.period, 0) AS period,
			COALESCE(f.rate_mode, '') AS rate_mode,
			COALESCE(f.latest_amount_raised, 0) AS latest_amount_raised,
			f.lastest_funding_date,
			COALESCE(f.sort, 0) AS sort, f.create_time, f.update_time
		FROM fb_fund f WHERE f.id = ?`, id).Scan(&raw).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if raw.ID == 0 {
		return nil, nil
	}
	vo := fundRowToVO(raw)
	return &vo, nil
}

// InsertFund 新增投信产品
func (d *FbMemberDal) InsertFund(ctx context.Context, in FundSaveInput) error {
	now := time.Now()
	poster := ""
	if in.Poster != nil {
		poster = *in.Poster
	}
	minAppend := in.MinAppendAmount
	if minAppend <= 0 {
		minAppend = defaultMinAppendAmount
	}
	rateMode := strings.TrimSpace(in.RateMode)
	if rateMode == "" {
		rateMode = "FIXED"
	}
	status := in.Status
	if status != 0 && status != 1 {
		status = 1
	}
	res := d.db.WithContext(ctx).Exec(`
		INSERT INTO fb_fund (
			id, code, symbol, name, company, ev, price, currency, description, poster,
			status, sold_out, rate_min, rate_max, rate, min_amount, min_append_amount, max_amount,
			period, rate_mode, latest_amount_raised, lastest_funding_date, sort, create_time, update_time
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
			?, ?, ?, ?, ?, ?, ?, ?,
			?, ?, ?, ?, ?, ?, ?)`,
		in.ID, in.Code, in.Symbol, in.Name, in.Company, in.Ev, in.Price, in.Currency, in.Description, nullIfEmpty(poster),
		status, in.SoldOut, in.RateMin, in.RateMax, in.Rate, in.MinAmount, minAppend, in.MaxAmount,
		in.Period, rateMode, in.LatestAmountRaised, in.LastestFundingDate, in.Sort, now, now)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// UpdateFund 按 id 更新投信产品
func (d *FbMemberDal) UpdateFund(ctx context.Context, in FundSaveInput) error {
	if in.ID <= 0 {
		return errx.BizErr("投信ID不能为空")
	}
	minAppend := in.MinAppendAmount
	if minAppend <= 0 {
		minAppend = defaultMinAppendAmount
	}
	rateMode := strings.TrimSpace(in.RateMode)
	if rateMode == "" {
		rateMode = "FIXED"
	}
	now := time.Now()

	// poster 为 nil 时不改库中海报
	if in.Poster != nil {
		res := d.db.WithContext(ctx).Exec(`
			UPDATE fb_fund SET
				code=?, symbol=?, name=?, company=?, ev=?, price=?, currency=?, description=?, poster=?,
				status=?, sold_out=?, rate_min=?, rate_max=?, rate=?,
				min_amount=?, min_append_amount=?, max_amount=?, period=?, rate_mode=?,
				latest_amount_raised=?, lastest_funding_date=?, sort=?, update_time=?
			WHERE id=?`,
			in.Code, in.Symbol, in.Name, in.Company, in.Ev, in.Price, in.Currency, in.Description, nullIfEmpty(*in.Poster),
			in.Status, in.SoldOut, in.RateMin, in.RateMax, in.Rate,
			in.MinAmount, minAppend, in.MaxAmount, in.Period, rateMode,
			in.LatestAmountRaised, in.LastestFundingDate, in.Sort, now, in.ID)
		if res.Error != nil {
			return errx.GORMErr(res.Error)
		}
		if res.RowsAffected == 0 {
			return errx.BizErr("投信产品不存在")
		}
		return nil
	}

	res := d.db.WithContext(ctx).Exec(`
		UPDATE fb_fund SET
			code=?, symbol=?, name=?, company=?, ev=?, price=?, currency=?, description=?,
			status=?, sold_out=?, rate_min=?, rate_max=?, rate=?,
			min_amount=?, min_append_amount=?, max_amount=?, period=?, rate_mode=?,
			latest_amount_raised=?, lastest_funding_date=?, sort=?, update_time=?
		WHERE id=?`,
		in.Code, in.Symbol, in.Name, in.Company, in.Ev, in.Price, in.Currency, in.Description,
		in.Status, in.SoldOut, in.RateMin, in.RateMax, in.Rate,
		in.MinAmount, minAppend, in.MaxAmount, in.Period, rateMode,
		in.LatestAmountRaised, in.LastestFundingDate, in.Sort, now, in.ID)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("投信产品不存在")
	}
	return nil
}

// DeleteFundsByIds 物理删除投信产品
func (d *FbMemberDal) DeleteFundsByIds(ctx context.Context, ids []int64) error {
	if len(ids) == 0 {
		return errx.BizErr("请选择要删除的投信")
	}
	ph := placeholders(len(ids))
	res := d.db.WithContext(ctx).Exec(
		`DELETE FROM fb_fund WHERE id IN (`+ph+`)`,
		int64SliceToAny(ids)...,
	)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

func nullIfEmpty(s string) any {
	if strings.TrimSpace(s) == "" {
		return nil
	}
	return s
}

// ParseFundID 解析投信主键
func ParseFundID(s string) (int64, error) {
	return parsePositiveInt64ID(s, "投信ID")
}

func parsePositiveInt64ID(s, label string) (int64, error) {
	s = strings.TrimSpace(s)
	if s == "" {
		return 0, errx.BizErr(label + "不能为空")
	}
	var id int64
	if _, err := fmt.Sscanf(s, "%d", &id); err != nil || id <= 0 {
		return 0, errx.BizErr(label + "无效")
	}
	return id, nil
}

// ParseFundDate 解析 yyyy-MM-dd 融资日期
func ParseFundDate(s string) (*time.Time, error) {
	s = strings.TrimSpace(s)
	if s == "" {
		return nil, nil
	}
	t, err := time.ParseInLocation("2006-01-02", s, time.Local)
	if err != nil {
		return nil, errx.BizErr("融资日期格式无效")
	}
	return &t, nil
}

// NormalizeFundSaveInput 校验并规范化写入参数（对齐 Java FbFundController）
func NormalizeFundSaveInput(in *FundSaveInput) error {
	in.Code = strings.TrimSpace(in.Code)
	in.Symbol = strings.TrimSpace(in.Symbol)
	in.Name = strings.TrimSpace(in.Name)
	in.Company = strings.TrimSpace(in.Company)
	if in.Code == "" {
		return errx.BizErr("投信代码不能为空")
	}
	if in.Symbol == "" {
		return errx.BizErr("符号不能为空")
	}
	if in.Name == "" {
		return errx.BizErr("投信名称不能为空")
	}
	if in.Company == "" {
		return errx.BizErr("公司不能为空")
	}
	if in.Rate <= 0 {
		return errx.BizErr("固定收益率不能为空")
	}
	if in.MinAmount < 0 {
		return errx.BizErr("最低投入金额不能为负数")
	}
	if in.MaxAmount < 0 {
		return errx.BizErr("最大投入金额不能为负数")
	}
	if in.MinAppendAmount <= 0 {
		in.MinAppendAmount = defaultMinAppendAmount
	}
	if in.Period <= 0 {
		return errx.BizErr("周期不能为空")
	}
	if in.RateMin < 0 || in.RateMax < 0 {
		return errx.BizErr("收益率不能为负数")
	}
	if in.RateMin > 0 && in.RateMax > 0 && in.RateMin > in.RateMax {
		return errx.BizErr("最低收益率不能大于最高收益率")
	}
	if in.MaxAmount > 0 && in.MinAmount > in.MaxAmount {
		return errx.BizErr("最低投入金额不能大于最大投入金额")
	}
	if in.MaxAmount > 0 && in.MinAppendAmount > in.MaxAmount {
		return errx.BizErr("最低追加金额不能大于最大投入金额")
	}
	return nil
}

// ResolveFundPoster 海报字段：空白/null、已存路径、base64 落盘
func ResolveFundPoster(uploadPath string, raw string, fundCode string, fundID int64) (*string, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return nil, nil
	}
	if upload.IsPosterAlreadyStored(raw) {
		v := raw
		return &v, nil
	}
	stem := fundCode
	if stem == "" && fundID > 0 {
		stem = IDStr(fundID)
	}
	path, err := upload.SaveFundPosterBase64(uploadPath, raw, stem)
	if err != nil {
		return nil, err
	}
	return &path, nil
}
