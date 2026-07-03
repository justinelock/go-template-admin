// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package news

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

type UpdateLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdateLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateLogic {
	return &UpdateLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UpdateLogic) Update(req *types.NotifyNewsSaveReq) error {
	id, err := dal.ParseMarketNewsID(req.Id)
	if err != nil {
		return err
	}
	in, err := saveReqToInput(req)
	if err != nil {
		return err
	}
	in.ID = id
	if err := dal.NormalizeMarketNewsSaveInput(&in); err != nil {
		return err
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetMarketNewsByID(l.ctx, id)
	if err != nil {
		return err
	}
	if row == nil {
		return errx.BizErr("新闻不存在")
	}
	return l.svcCtx.Dal.FbMemberDal.UpdateMarketNews(l.ctx, in)
}
