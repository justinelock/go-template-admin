// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package dashboard

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/dashboard"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func StatisticsHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.DashboardStatisticsQuery
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := dashboard.NewStatisticsLogic(r.Context(), svcCtx)
		resp, err := l.Statistics(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
