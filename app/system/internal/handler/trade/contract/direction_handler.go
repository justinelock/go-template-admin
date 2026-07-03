// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/trade/contract"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func DirectionHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.TradeContractDirectionReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := contract.NewDirectionLogic(r.Context(), svcCtx)
		err := l.Direction(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, nil)
		}
	}
}
