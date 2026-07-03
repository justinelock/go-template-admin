package dal

// 市场新闻 DAL：fb_market_news 分页、详情、增改（对齐 Java FbMarketNewsServiceImpl）

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
)

// MarketNewsPageQuery 市场新闻列表筛选
type MarketNewsPageQuery struct {
	Keyword    string
	Source     string
	Category   string
	BeginTime  string
	EndTime    string
	OrderField string
	Order      string
	PageNum    int64
	PageSize   int64
}

type marketNewsListRow struct {
	ID          int64
	Title       string
	Summary     string
	Content     string
	Source      string
	Category    string
	URL         string
	ImageURL    string
	ViewCount   int
	PublishTime *time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// MarketNewsVO 市场新闻对外结构
type MarketNewsVO struct {
	ID          int64
	Title       string
	Summary     string
	Content     string
	Source      string
	Category    string
	URL         string
	ImageURL    string
	ViewCount   int
	PublishTime *time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// MarketNewsSaveInput 新增/修改写入字段
type MarketNewsSaveInput struct {
	ID          int64
	Title       string
	Summary     string
	Content     string
	Source      string
	Category    string
	URL         string
	ImageURL    string
	ViewCount   int
	PublishTime *time.Time
}

// PageMarketNews 分页查 fb_market_news；默认按 COALESCE(publish_time, created_at) DESC
func (d *FbMemberDal) PageMarketNews(ctx context.Context, q MarketNewsPageQuery) ([]MarketNewsVO, int64, error) {
	where := []string{"1=1"}
	var args []any

	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		where = append(where, "(n.title LIKE ? OR n.summary LIKE ?)")
		p := "%" + kw + "%"
		args = append(args, p, p)
	}
	if src := strings.TrimSpace(q.Source); src != "" {
		where = append(where, "n.source LIKE ?")
		args = append(args, "%"+src+"%")
	}
	if cat := strings.TrimSpace(q.Category); cat != "" {
		where = append(where, "n.category LIKE ?")
		args = append(args, "%"+cat+"%")
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "COALESCE(n.publish_time, n.created_at) BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}

	w := strings.Join(where, " AND ")
	base := `FROM fb_market_news n WHERE ` + w

	var total int64
	if err := d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if total == 0 {
		return []MarketNewsVO{}, 0, nil
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize

	orderSQL := buildMarketNewsOrderSQL(q.OrderField, q.Order)
	var raw []marketNewsListRow
	listSQL := `SELECT n.id, COALESCE(n.title,'') AS title,
		COALESCE(n.summary,'') AS summary, COALESCE(n.content,'') AS content,
		COALESCE(n.source,'') AS source, COALESCE(n.category,'') AS category,
		COALESCE(n.url,'') AS url, COALESCE(n.image_url,'') AS image_url,
		COALESCE(n.view_count,0) AS view_count, n.publish_time,
		n.created_at, n.updated_at ` + base + orderSQL + ` LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	if err := d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&raw).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	out := make([]MarketNewsVO, 0, len(raw))
	for _, r := range raw {
		out = append(out, marketNewsRowToVO(r))
	}
	return out, total, nil
}

func buildMarketNewsOrderSQL(orderField, order string) string {
	col := "COALESCE(n.publish_time, n.created_at)"
	switch strings.TrimSpace(strings.ToLower(orderField)) {
	case "publish_time", "publishtime":
		col = "COALESCE(n.publish_time, n.created_at)"
	case "created_at", "createdat":
		col = "n.created_at"
	case "view_count", "viewcount":
		col = "n.view_count"
	}
	dir := "DESC"
	if strings.EqualFold(strings.TrimSpace(order), "asc") {
		dir = "ASC"
	}
	return fmt.Sprintf(" ORDER BY %s %s", col, dir)
}

func marketNewsRowToVO(r marketNewsListRow) MarketNewsVO {
	return MarketNewsVO{
		ID:          r.ID,
		Title:       r.Title,
		Summary:     r.Summary,
		Content:     r.Content,
		Source:      r.Source,
		Category:    r.Category,
		URL:         r.URL,
		ImageURL:    r.ImageURL,
		ViewCount:   r.ViewCount,
		PublishTime: r.PublishTime,
		CreatedAt:   r.CreatedAt,
		UpdatedAt:   r.UpdatedAt,
	}
}

// GetMarketNewsByID 按主键查市场新闻
func (d *FbMemberDal) GetMarketNewsByID(ctx context.Context, id int64) (*MarketNewsVO, error) {
	if id <= 0 {
		return nil, nil
	}
	var raw marketNewsListRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT n.id, COALESCE(n.title,'') AS title,
			COALESCE(n.summary,'') AS summary, COALESCE(n.content,'') AS content,
			COALESCE(n.source,'') AS source, COALESCE(n.category,'') AS category,
			COALESCE(n.url,'') AS url, COALESCE(n.image_url,'') AS image_url,
			COALESCE(n.view_count,0) AS view_count, n.publish_time,
			n.created_at, n.updated_at
		FROM fb_market_news n WHERE n.id = ?`, id).Scan(&raw).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if raw.ID == 0 {
		return nil, nil
	}
	vo := marketNewsRowToVO(raw)
	return &vo, nil
}

// InsertMarketNews 新增市场新闻
func (d *FbMemberDal) InsertMarketNews(ctx context.Context, in MarketNewsSaveInput) error {
	now := time.Now()
	res := d.db.WithContext(ctx).Exec(`
		INSERT INTO fb_market_news (
			id, title, summary, content, source, category, url, image_url,
			view_count, publish_time, created_at, updated_at
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		in.ID, in.Title, nullIfEmpty(in.Summary), nullIfEmpty(in.Content),
		nullIfEmpty(in.Source), nullIfEmpty(in.Category), nullIfEmpty(in.URL), nullIfEmpty(in.ImageURL),
		in.ViewCount, in.PublishTime, now, now)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// UpdateMarketNews 按 id 更新市场新闻
func (d *FbMemberDal) UpdateMarketNews(ctx context.Context, in MarketNewsSaveInput) error {
	if in.ID <= 0 {
		return errx.BizErr("新闻ID不能为空")
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Exec(`
		UPDATE fb_market_news SET
			title=?, summary=?, content=?, source=?, category=?, url=?, image_url=?,
			view_count=?, publish_time=?, updated_at=?
		WHERE id=?`,
		in.Title, nullIfEmpty(in.Summary), nullIfEmpty(in.Content),
		nullIfEmpty(in.Source), nullIfEmpty(in.Category), nullIfEmpty(in.URL), nullIfEmpty(in.ImageURL),
		in.ViewCount, in.PublishTime, now, in.ID)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("新闻不存在")
	}
	return nil
}

// ParseMarketNewsID 解析新闻主键
func ParseMarketNewsID(s string) (int64, error) {
	return parsePositiveInt64ID(s, "新闻ID")
}

// NormalizeMarketNewsSaveInput 校验写入参数
func NormalizeMarketNewsSaveInput(in *MarketNewsSaveInput) error {
	in.Title = strings.TrimSpace(in.Title)
	if in.Title == "" {
		return errx.BizErr("新闻标题不能为空")
	}
	if in.ViewCount < 0 {
		in.ViewCount = 0
	}
	return nil
}

// ParseMarketNewsPublishTime 解析发布时间字符串
func ParseMarketNewsPublishTime(s string) (*time.Time, error) {
	s = strings.TrimSpace(s)
	if s == "" {
		return nil, nil
	}
	layouts := []string{
		"2006-01-02 15:04:05",
		"2006-01-02T15:04:05",
		"2006-01-02",
	}
	for _, layout := range layouts {
		if t, err := time.ParseInLocation(layout, s, time.Local); err == nil {
			return &t, nil
		}
	}
	return nil, errx.BizErr("发布时间格式不正确")
}
