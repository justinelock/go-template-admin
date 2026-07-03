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

func (l *UpdateLogic) Update(req *types.ProductConfigSaveReq) error {
	id, err := dal.ParseFundProductID(req.Id)
	if err != nil {
		return err
	}
	in := saveReqToInput(req)
	in.ID = id
	if err := dal.NormalizeFundProductSaveInput(&in); err != nil {
		return err
	}
	return l.svcCtx.Dal.FbMemberDal.UpdateFundProduct(l.ctx, in)
}
