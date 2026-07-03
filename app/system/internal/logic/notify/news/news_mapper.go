package news

import (
	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/types"
)

// mapNewsToItem 将 DAL MarketNewsVO 映射为 API NotifyNewsItem
func mapNewsToItem(r dal.MarketNewsVO) *types.NotifyNewsItem {
	item := &types.NotifyNewsItem{
		Id:        dal.IDStr(r.ID),
		Title:     r.Title,
		Summary:   r.Summary,
		Content:   r.Content,
		Source:    r.Source,
		Category:  r.Category,
		Url:       r.URL,
		ImageUrl:  r.ImageURL,
		ViewCount: r.ViewCount,
		CreatedAt: dal.FormatFbTimeVal(r.CreatedAt),
		UpdatedAt: dal.FormatFbTimeVal(r.UpdatedAt),
	}
	if r.PublishTime != nil && !r.PublishTime.IsZero() {
		item.PublishTime = dal.FormatFbTimeVal(*r.PublishTime)
	}
	return item
}

func saveReqToInput(req *types.NotifyNewsSaveReq) (dal.MarketNewsSaveInput, error) {
	pub, err := dal.ParseMarketNewsPublishTime(req.PublishTime)
	if err != nil {
		return dal.MarketNewsSaveInput{}, err
	}
	return dal.MarketNewsSaveInput{
		Title:       req.Title,
		Summary:     req.Summary,
		Content:     req.Content,
		Source:      req.Source,
		Category:    req.Category,
		URL:         req.Url,
		ImageURL:    req.ImageUrl,
		ViewCount:   req.ViewCount,
		PublishTime: pub,
	}, nil
}
