// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/invest/list"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func AddHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.InvestListSaveReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := list.NewAddLogic(r.Context(), svcCtx)
		err := l.Add(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			// 须返回 {code,msg}，否则 postWithMsg 无法提示成功且弹窗不关闭
			httpx.OkJsonCtx(r.Context(), w, nil)
		}
	}
}
