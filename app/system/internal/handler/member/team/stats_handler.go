// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"ovra/app/system/internal/logic/member/team"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
)

func StatsHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.MemberTeamQuery
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		// stats 仅 keyword 参与统计；status 等列表筛选项在此忽略
		l := team.NewStatsLogic(r.Context(), svcCtx)
		resp, err := l.Stats(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
