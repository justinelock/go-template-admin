// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package sse

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/dev/sse"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func SendHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.SseSendReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := sse.NewSendLogic(r.Context(), svcCtx)
		err := l.Send(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.Ok(w)
		}
	}
}
