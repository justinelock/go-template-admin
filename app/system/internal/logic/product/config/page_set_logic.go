// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package config

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 产品配置分页（对齐 Java FbFundProductServiceImpl.getPageData）
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

func (l *PageSetLogic) PageSet(req *types.PageSetProductConfigReq) (resp *types.PageSetProductConfigResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageFundProducts(l.ctx, dal.FundProductPageQuery{
		Keyword:    req.Keyword,
		Code:       req.Code,
		Name:       req.Name,
		Type:       req.Type,
		Status:     req.Status,
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
	items := make([]*types.ProductConfigItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, mapProductToItem(r))
	}
	return &types.PageSetProductConfigResp{Rows: items, Total: total}, nil
}
