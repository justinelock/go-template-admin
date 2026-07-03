// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package config

import (
	"context"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

type DeleteLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDeleteLogic(ctx context.Context, svcCtx *svc.ServiceContext) *DeleteLogic {
	return &DeleteLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *DeleteLogic) Delete(req *types.IdsReq) error {
	if req == nil || strings.TrimSpace(req.Ids) == "" {
		return errx.BizErr("请选择要删除的产品")
	}
	parts := strings.Split(req.Ids, ",")
	ids := make([]int64, 0, len(parts))
	for _, p := range parts {
		id, err := dal.ParseFundProductID(strings.TrimSpace(p))
		if err != nil {
			return err
		}
		ids = append(ids, id)
	}
	return l.svcCtx.Dal.FbMemberDal.DeleteFundProductsByIds(l.ctx, ids)
}
