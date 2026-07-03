// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package config

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

func (l *AddLogic) Add(req *types.ProductConfigSaveReq) error {
	in := saveReqToInput(req)
	if err := dal.NormalizeFundProductSaveInput(&in); err != nil {
		return err
	}
	in.ID = utils.GetIDInt64()
	return l.svcCtx.Dal.FbMemberDal.InsertFundProduct(l.ctx, in)
}
