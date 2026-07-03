// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package news

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 市场新闻分页（对齐 Java FbMarketNewsServiceImpl.page）
type PageSetLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewPageSetLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PageSetLogic {
	return &PageSetLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *PageSetLogic) PageSet(req *types.PageSetNotifyNewsReq) (resp *types.PageSetNotifyNewsResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageMarketNews(l.ctx, dal.MarketNewsPageQuery{
		Keyword:    req.Keyword,
		Source:     req.Source,
		Category:   req.Category,
		BeginTime:  req.BeginTime,
		EndTime:    req.EndTime,
		OrderField: req.OrderField,
		Order:      req.Order,
		PageNum:    req.PageNum,
		PageSize:   req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	items := make([]*types.NotifyNewsItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, mapNewsToItem(r))
	}
	return &types.PageSetNotifyNewsResp{Rows: items, Total: total}, nil
}
