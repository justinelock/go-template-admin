// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package version

import (
	"context"

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

func (l *UpdateLogic) Update(req *types.AppReleaseVersionSaveReq) error {
	in := saveReqToInput(req)
	return l.svcCtx.Dal.AppDal.UpdateReleaseVersion(l.ctx, in)
}
