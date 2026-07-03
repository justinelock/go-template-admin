package brand

import (
	"context"
	"net/http"

	apphelper "ovra/app/system/internal/logic/app"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/upload"

	"github.com/zeromicro/go-zero/core/logx"
)

type UploadImageLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
	r      *http.Request
}

func NewUploadImageLogic(ctx context.Context, svcCtx *svc.ServiceContext, r *http.Request) *UploadImageLogic {
	return &UploadImageLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
		r:      r,
	}
}

func (l *UploadImageLogic) UploadImage() (*types.AppBrandingUploadResp, error) {
	if err := l.r.ParseMultipartForm(8 << 20); err != nil {
		return nil, err
	}
	_ = apphelper.ResolveOperator(l.ctx, l.svcCtx)
	kind := l.r.URL.Query().Get("kind")
	file, header, err := l.r.FormFile("file")
	if err != nil {
		return nil, err
	}
	defer file.Close()
	url, err := upload.SaveBrandingMultipart(l.svcCtx.Config.FileUpload.Path, file, header, kind)
	if err != nil {
		return nil, err
	}
	return &types.AppBrandingUploadResp{Url: url, Src: url}, nil
}
