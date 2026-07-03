// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package walletApply

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/fund/walletApply"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func CurrentMonthFlowHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.FundWalletApplyCurrentMonthFlowReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := walletApply.NewCurrentMonthFlowLogic(r.Context(), svcCtx)
		resp, err := l.CurrentMonthFlow(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
