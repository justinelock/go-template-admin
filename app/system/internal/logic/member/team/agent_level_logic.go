// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// AgentLevelLogic 调整团队代理层级（对齐 Java FbUsersController#updateAgentLevel）
type AgentLevelLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAgentLevelLogic(ctx context.Context, svcCtx *svc.ServiceContext) *AgentLevelLogic {
	return &AgentLevelLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *AgentLevelLogic) AgentLevel(req *types.MemberTeamAgentLevelReq) (resp *types.MemberTeamAgentLevelResp, err error) {
	if strings.TrimSpace(req.UserId) == "" {
		return nil, errx.BizErr("用户ID不能为空")
	}
	userID, err := strconv.ParseInt(strings.TrimSpace(req.UserId), 10, 64)
	if err != nil || userID <= 0 {
		return nil, errx.BizErr("用户ID不能为空")
	}
	if err = l.svcCtx.Dal.FbMemberDal.UpdateTeamAgentLevel(l.ctx, userID, req.AgentLevel); err != nil {
		return nil, err
	}
	return &types.MemberTeamAgentLevelResp{
		UserId:     dal.IDStr(userID),
		AgentLevel: req.AgentLevel,
	}, nil
}
