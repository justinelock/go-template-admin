// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package wallet

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/member/wallet"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func AddOrSubtractHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.MemberWalletAddOrSubtractReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := wallet.NewAddOrSubtractLogic(r.Context(), svcCtx)
		err := l.AddOrSubtract(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			// 须走 OkJsonCtx + helper.OkHandler，返回 {code,msg}；httpx.Ok 无 body 会导致前端判定失败
			httpx.OkJsonCtx(r.Context(), w, nil)
		}
	}
}
