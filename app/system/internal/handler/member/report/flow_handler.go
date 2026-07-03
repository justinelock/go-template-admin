// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package report

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/member/report"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func FlowHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.PageSetMemberReportFlowReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := report.NewFlowLogic(r.Context(), svcCtx)
		resp, err := l.Flow(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
