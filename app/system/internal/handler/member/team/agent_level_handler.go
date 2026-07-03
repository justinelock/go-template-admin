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

func AgentLevelHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.MemberTeamAgentLevelReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := team.NewAgentLevelLogic(r.Context(), svcCtx)
		resp, err := l.AgentLevel(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			// 须 OkJsonCtx 返回 {code,msg,data}；httpx.Ok 无 body 会导致前端判定失败
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
