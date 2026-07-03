// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package brand

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type ActiveLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewActiveLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ActiveLogic {
	return &ActiveLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *ActiveLogic) Active() (resp *types.AppBrandingItem, err error) {
	row, err := l.svcCtx.Dal.AppDal.GetActiveBranding(l.ctx)
	if err != nil {
		return nil, err
	}
	if row == nil {
		return defaultBrandingItem(), nil
	}
	return mapBrandingToItem(*row), nil
}
