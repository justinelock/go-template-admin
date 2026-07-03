// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package sse

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/dev/sse"
	"ovra/app/system/internal/svc"
)

func StatusHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := sse.NewStatusLogic(r.Context(), svcCtx)
		resp, err := l.Status()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
