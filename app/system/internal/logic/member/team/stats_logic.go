// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// StatsLogic 团队代理统计（对齐 Java TeamServiceImpl.getTeamStatsAll）
type StatsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewStatsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *StatsLogic {
	return &StatsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Stats 团队树各级人数与余额汇总；stats 仅使用 keyword 定位根用户，忽略 status/注册时间
func (l *StatsLogic) Stats(req *types.MemberTeamQuery) (resp *types.MemberTeamStatsResp, err error) {
	memberDal := l.svcCtx.Dal.FbMemberDal

	// 1. keyword 模糊匹配 -> 根用户 ID；无 keyword 或无匹配则为 0（全局统计）
	rootUserID, err := memberDal.ResolveStatsRootUserID(l.ctx, req.Keyword)
	if err != nil {
		return nil, err
	}

	var stats *dal.TeamStatsRow
	var totalBalance float64

	if rootUserID == 0 {
		// 2a. 全局：顶层用户树统计 + 全库钱包余额
		stats, err = memberDal.GetGlobalTeamStats(l.ctx)
		if err != nil {
			return nil, err
		}
		totalBalance, err = memberDal.SumAllWalletBalance(l.ctx)
		if err != nil {
			return nil, err
		}
	} else {
		// 2b. 指定根用户：读 agent_level -> 子树人数 -> 按深度截断 -> 下级钱包 SUM
		agentLevel, err := memberDal.GetTeamUserAgentLevel(l.ctx, rootUserID)
		if err != nil {
			return nil, err
		}
		al := dal.NormalizeTeamAgentLevel(agentLevel)

		stats, err = memberDal.GetTeamStatsByUserID(l.ctx, rootUserID)
		if err != nil {
			return nil, err
		}
		dal.ApplyTeamStatsAgentLevelCap(stats, al)

		descendantIDs, err := memberDal.CollectTeamDescendantIDs(l.ctx, rootUserID, al)
		if err != nil {
			return nil, err
		}
		if len(descendantIDs) > 0 {
			totalBalance, err = memberDal.SumWalletBalanceByUserIDs(l.ctx, descendantIDs)
			if err != nil {
				return nil, err
			}
		}
	}

	return &types.MemberTeamStatsResp{
		TotalMembers:     stats.TotalMembers,
		Level1Members:    stats.Level1Members,
		Level2Members:    stats.Level2Members,
		Level3Members:    stats.Level3Members,
		Level4Members:    stats.Level4Members,
		Level5Members:    stats.Level5Members,
		TotalTeamBalance: totalBalance,
	}, nil
}
