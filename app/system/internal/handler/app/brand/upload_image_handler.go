package brand

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/app/brand"
	"ovra/app/system/internal/svc"
)

// UploadImageHandler 品牌图片 multipart 上传
func UploadImageHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := brand.NewUploadImageLogic(r.Context(), svcCtx, r)
		resp, err := l.UploadImage()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
