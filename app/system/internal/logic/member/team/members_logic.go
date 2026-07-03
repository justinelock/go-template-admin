// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

import (
	"context"
	"strconv"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// MembersLogic 下级团队成员分页
type MembersLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewMembersLogic(ctx context.Context, svcCtx *svc.ServiceContext) *MembersLogic {
	return &MembersLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *MembersLogic) Members(req *types.PageSetMemberTeamMembersReq) (resp *types.PageSetMemberTeamMembersResp, err error) {
	userID, err := strconv.ParseInt(req.UserId, 10, 64)
	if err != nil || userID <= 0 {
		return nil, errx.BizErr("用户不存在")
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageTeamMembers(l.ctx, userID, req.PageNum, req.PageSize)
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberTeamMemberItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.MemberTeamMemberItem{
			Level:         int64(r.Level),
			Username:      r.Username,
			TotalAssets:   r.TotalAssets,
			TotalDeposit:  r.TotalDeposit,
			TotalInvest:   r.TotalInvest,
			TotalWithdraw: r.TotalWithdraw,
		})
	}
	return &types.PageSetMemberTeamMembersResp{Rows: items, Total: total}, nil
}
