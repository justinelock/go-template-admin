// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package encrypt

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/dev/encrypt"
	"ovra/app/system/internal/svc"
)

func ResponseHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := encrypt.NewResponseLogic(r.Context(), svcCtx)
		resp, err := l.Response()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
