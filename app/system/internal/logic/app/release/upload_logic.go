package release

import (
	"context"
	"net/http"

	apphelper "ovra/app/system/internal/logic/app"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/upload"

	"github.com/zeromicro/go-zero/core/logx"
)

type UploadLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
	r      *http.Request
}

func NewUploadLogic(ctx context.Context, svcCtx *svc.ServiceContext, r *http.Request) *UploadLogic {
	return &UploadLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
		r:      r,
	}
}

func (l *UploadLogic) Upload() (*types.AppReleaseUploadResult, error) {
	// PUT multipart 需显式解析（Go 默认仅 POST 自动解析）
	if err := l.r.ParseMultipartForm(32 << 20); err != nil {
		return nil, err
	}
	file, header, err := l.r.FormFile("file")
	if err != nil {
		return nil, err
	}
	defer file.Close()
	domain := l.r.FormValue("domain")
	fileName := l.r.FormValue("fileName")
	cfg := apphelper.ReleaseUploadSettings(l.svcCtx)
	result, err := upload.SaveAppReleasePackage(cfg, file, header, domain, fileName)
	if err != nil {
		return nil, err
	}
	// 上传成功后回写版本表（APK 同步分发地址；IPA 仅写文件地址）
	if err := l.svcCtx.Dal.AppDal.ApplyUploadedPackage(l.ctx, result.URL, result.Kind, result.FileName); err != nil {
		return nil, err
	}
	return &types.AppReleaseUploadResult{
		Url:      result.URL,
		Path:     result.Path,
		Domain:   result.Domain,
		FileName: result.FileName,
		Kind:     result.Kind,
	}, nil
}
