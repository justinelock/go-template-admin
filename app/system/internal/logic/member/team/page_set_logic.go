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

// PageSetLogic 团队列表分页查询
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

// PageSet 分页查询团队列表（含上级 agent 与直属下级数）
func (l *PageSetLogic) PageSet(req *types.PageSetMemberTeamReq) (resp *types.PageSetMemberTeamResp, err error) {
	f := dal.MemberListFilter{
		Keyword:   req.Keyword,
		Status:    req.Status,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageTeams(l.ctx, f)
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberTeamItem, 0, len(rows))
	for _, r := range rows {
		item := &types.MemberTeamItem{
			Id:               dal.IDStr(r.ID),
			Username:         r.Username,
			RealName:         r.RealName,
			Level:            int64(r.Level),
			Status:           r.Status,
			TeamSize:         int64(r.TeamSize),
			Level1Members:    r.Level1Members,
			AgentLevel:       int64(r.AgentLevel),
			WalletCount:      r.WalletCount,
			Balance:          r.Balance,
			TotalTeamBalance: r.TotalTeamBalance,
			CreatedAt:        dal.FormatFbTimeVal(r.CreatedAt),
		}
		if r.ParentID > 0 {
			item.Agent = &types.MemberTeamAgent{
				Id:       dal.IDStr(r.ParentID),
				Username: r.ParentUsername,
				RealName: r.ParentRealName,
			}
		}
		items = append(items, item)
	}
	return &types.PageSetMemberTeamResp{Rows: items, Total: total}, nil
}
