// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package withdraw

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/fund/withdraw"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func ApprovedHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.IdReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := withdraw.NewApprovedLogic(r.Context(), svcCtx)
		err := l.Approved(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, nil)
		}
	}
}
