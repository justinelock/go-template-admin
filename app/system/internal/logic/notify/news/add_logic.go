// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package news

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/utils"

	"github.com/zeromicro/go-zero/core/logx"
)

type AddLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAddLogic(ctx context.Context, svcCtx *svc.ServiceContext) *AddLogic {
	return &AddLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *AddLogic) Add(req *types.NotifyNewsSaveReq) error {
	in, err := saveReqToInput(req)
	if err != nil {
		return err
	}
	if err := dal.NormalizeMarketNewsSaveInput(&in); err != nil {
		return err
	}
	in.ID = utils.GetIDInt64()
	return l.svcCtx.Dal.FbMemberDal.InsertMarketNews(l.ctx, in)
}
