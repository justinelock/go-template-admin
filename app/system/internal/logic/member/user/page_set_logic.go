// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package user

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 业务用户列表分页查询
type PageSetLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewPageSetLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PageSetLogic {
	return &PageSetLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// PageSet 分页查询业务用户（fb_users 聚合 + Redis onlineStatus）
func (l *PageSetLogic) PageSet(req *types.PageSetMemberUserReq) (resp *types.PageSetMemberUserResp, err error) {
	f := dal.MemberListFilter{
		Keyword:    req.Keyword,
		AuthStatus: req.AuthStatus,
		Deleted:    req.Deleted,
		BeginTime:  req.BeginTime,
		EndTime:    req.EndTime,
		PageNum:    req.PageNum,
		PageSize:   req.PageSize,
	}
	// fb_users 联表 USD 钱包与投信持仓（分红来自 profit_log）
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageUsers(l.ctx, f)
	if err != nil {
		return nil, err
	}
	userIDs := make([]int64, 0, len(rows))
	for _, r := range rows {
		userIDs = append(userIDs, r.ID)
	}
	// token 在线（online:user）或近 5 分钟 presence 活跃 → onlineStatus
	onlineMap := l.svcCtx.Dal.FbUserRedisDal.BatchOnlineStatus(l.ctx, userIDs)

	items := make([]*types.MemberUserItem, 0, len(rows))
	for _, r := range rows {
		online := onlineMap[r.ID]
		items = append(items, &types.MemberUserItem{
			Id:                   dal.IDStr(r.ID),
			Username:             r.Username,
			RealName:             r.RealName,
			IdCard:               r.IDCard,
			AgentLevel:           int64(r.AgentLevel),
			InviteCode:           r.InviteCode,
			CommissionRate:       r.CommissionRate,
			TotalCommission:      r.TotalCommission,
			TotalBalance:         r.TotalBalance,
			FundPositionAmount:   r.FundPositionAmount,
			FundPositionDividend: r.FundPositionDividend,
			Status:               r.Status,
			OnlineStatus:         online,
			LastLogin:            dal.FormatFbTime(r.LastLogin),
			CreatedAt:            dal.FormatFbTimeVal(r.CreatedAt),
		})
	}
	return &types.PageSetMemberUserResp{Rows: items, Total: total}, nil
}
