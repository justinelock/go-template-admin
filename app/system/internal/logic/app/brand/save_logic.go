// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package brand

import (
	"context"

	apphelper "ovra/app/system/internal/logic/app"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type SaveLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSaveLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SaveLogic {
	return &SaveLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *SaveLogic) Save(req *types.AppBrandingSaveReq) (*types.AppBrandingItem, error) {
	operator := apphelper.ResolveOperator(l.ctx, l.svcCtx)
	in, err := saveReqToInput(req, l.svcCtx.Config.FileUpload.Path, operator)
	if err != nil {
		return nil, err
	}
	if err := l.svcCtx.Dal.AppDal.SaveBranding(l.ctx, in); err != nil {
		return nil, err
	}
	// 保存后返回最新配置（含 bump 后的 revision）
	return NewActiveLogic(l.ctx, l.svcCtx).Active()
}
