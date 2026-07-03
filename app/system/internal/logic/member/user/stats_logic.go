// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package user

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// StatsLogic 业务用户活跃统计（Redis 全局，对齐 Java online-statistics）
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

// Stats 返回 Redis 全局在线/今日登录/近 5 分钟活跃用户数（忽略列表筛选参数）
func (l *StatsLogic) Stats(_ *types.MemberUserQuery) (resp *types.MemberUserStatsResp, err error) {
	// KEYS online:user:* / SCARD login:today / ZSET fb:presence:active（5 分钟窗口）
	online, today, sessions := l.svcCtx.Dal.FbUserRedisDal.OnlineStatistics(l.ctx)
	return &types.MemberUserStatsResp{
		TotalOnlineUsers:    online,
		TodayLogins:         today,
		TotalActiveSessions: sessions,
	}, nil
}
