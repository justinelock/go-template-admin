package dal

import (
	"context"
	"strconv"
	"time"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/redis"
)

// 与 Java com.fubang.common.redis.RedisKeys / UserPresenceRedisService 保持一致
const (
	fbRedisKeyOnlineUserPrefix = "online:user:"
	fbRedisKeyTodayLogin       = "login:today"
	fbRedisKeyPresenceZset     = "fb:presence:active"
	fbPresenceWindowMinutes    = 5
)

// FbUserRedisDal 业务用户在线/活跃 Redis 统计（对齐 fubang-backend online-statistics）
type FbUserRedisDal struct {
	rds *redis.Redis
}

func NewFbUserRedisDal(rds *redis.Redis) *FbUserRedisDal {
	return &FbUserRedisDal{rds: rds}
}

func fbOnlineUserKey(userID int64) string {
	return fbRedisKeyOnlineUserPrefix + strconv.FormatInt(userID, 10)
}

// OnlineStatistics 全局三项统计（对齐 Java countStat；Redis 异常时单项记 0 并打日志）
func (d *FbUserRedisDal) OnlineStatistics(ctx context.Context) (totalOnline, todayLogins, activeSessions int64) {
	if d == nil || d.rds == nil {
		return 0, 0, 0
	}
	// token 在线数：KEYS online:user:*（与 Java 一致，大 key 量可改 SCAN）
	keys, err := d.rds.KeysCtx(ctx, fbRedisKeyOnlineUserPrefix+"*")
	if err != nil {
		logx.WithContext(ctx).Errorf("FbUserRedisDal count online users failed: %v", err)
	} else {
		totalOnline = int64(len(keys))
	}
	// 今日登录：SCARD login:today
	today, err := d.rds.ScardCtx(ctx, fbRedisKeyTodayLogin)
	if err != nil {
		logx.WithContext(ctx).Errorf("FbUserRedisDal count today logins failed: %v", err)
	} else {
		todayLogins = today
	}
	// 近 5 分钟活跃：ZSET fb:presence:active
	activeSessions = int64(d.countActiveInWindow(ctx))
	return totalOnline, todayLogins, activeSessions
}

// countActiveInWindow 先清理窗口外成员再 ZCOUNT（对齐 UserPresenceRedisService.countActiveInWindow）
func (d *FbUserRedisDal) countActiveInWindow(ctx context.Context) int {
	cutoff := time.Now().Add(-time.Duration(fbPresenceWindowMinutes) * time.Minute).UnixMilli()
	// 清理过期 member，与 Java pruneAndGetCutoff 一致
	_, _ = d.rds.ZremrangebyscoreCtx(ctx, fbRedisKeyPresenceZset, 0, cutoff-1)
	cnt, err := d.rds.ZcountCtx(ctx, fbRedisKeyPresenceZset, cutoff, 1<<62)
	if err != nil {
		logx.WithContext(ctx).Errorf("FbUserRedisDal count active sessions failed: %v", err)
		return 0
	}
	return cnt
}

// BatchOnlineStatus 批量计算列表行 onlineStatus：online:user 存在或 presence 窗口内活跃则为 1
func (d *FbUserRedisDal) BatchOnlineStatus(ctx context.Context, userIDs []int64) map[int64]int64 {
	out := make(map[int64]int64, len(userIDs))
	if d == nil || d.rds == nil || len(userIDs) == 0 {
		return out
	}
	cutoff := time.Now().Add(-time.Duration(fbPresenceWindowMinutes) * time.Minute).UnixMilli()
	for _, id := range userIDs {
		online := false
		// 优先：session token 是否仍在线
		if ok, err := d.rds.ExistsCtx(ctx, fbOnlineUserKey(id)); err == nil && ok {
			online = true
		}
		// 否则：presence ZSET 窗口内最后活跃时间
		if !online {
			score, err := d.rds.ZscoreByFloatCtx(ctx, fbRedisKeyPresenceZset, strconv.FormatInt(id, 10))
			if err == nil && int64(score) >= cutoff {
				online = true
			}
		}
		if online {
			out[id] = 1
		} else {
			out[id] = 0
		}
	}
	return out
}
