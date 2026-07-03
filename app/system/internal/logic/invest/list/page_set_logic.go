// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 投信产品分页（对齐 Java FundServiceImpl.getPageData）
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

func (l *PageSetLogic) PageSet(req *types.PageSetInvestListReq) (resp *types.PageSetInvestListResp, err error) {
	// 组装筛选条件，查 fb_fund 分页
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageFunds(l.ctx, dal.FundPageQuery{
		Keyword:    req.Keyword,
		Name:       req.Name,
		Code:       req.Code,
		Status:     req.Status,
		SoldOut:    req.SoldOut,
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
	items := make([]*types.InvestListItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, mapFundToItem(r))
	}
	return &types.PageSetInvestListResp{Rows: items, Total: total}, nil
}
