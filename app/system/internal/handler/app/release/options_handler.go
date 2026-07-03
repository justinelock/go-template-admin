// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package release

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/app/release"
	"ovra/app/system/internal/svc"
)

func OptionsHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := release.NewOptionsLogic(r.Context(), svcCtx)
		resp, err := l.Options()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
