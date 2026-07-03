// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package position

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/invest/position"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func ProfitBeforeHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.InvestPositionProfitBeforeReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := position.NewProfitBeforeLogic(r.Context(), svcCtx)
		resp, err := l.ProfitBefore(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
