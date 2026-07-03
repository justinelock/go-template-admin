// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package release

import (
	"context"

	apphelper "ovra/app/system/internal/logic/app"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/upload"

	"github.com/zeromicro/go-zero/core/logx"
)

type OptionsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewOptionsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *OptionsLogic {
	return &OptionsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *OptionsLogic) Options() (resp *types.AppReleaseUploadOptions, err error) {
	cfg := apphelper.ReleaseUploadSettings(l.svcCtx)
	def, allowed, pattern, wwwroot := upload.BuildUploadOptions(cfg)
	return &types.AppReleaseUploadOptions{
		DefaultDomain:  def,
		AllowedDomains: allowed,
		UrlPattern:     pattern,
		WwwrootBase:    wwwroot,
	}, nil
}
