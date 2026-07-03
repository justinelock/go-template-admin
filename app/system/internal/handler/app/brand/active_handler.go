// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package brand

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/app/brand"
	"ovra/app/system/internal/svc"
)

func ActiveHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := brand.NewActiveLogic(r.Context(), svcCtx)
		resp, err := l.Active()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
