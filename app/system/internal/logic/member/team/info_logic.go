// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

import (
	"context"
	"strconv"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// InfoLogic 团队详情弹窗
type InfoLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewInfoLogic(ctx context.Context, svcCtx *svc.ServiceContext) *InfoLogic {
	return &InfoLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *InfoLogic) Info(req *types.IdReq) (resp *types.MemberTeamDetailResp, err error) {
	userID, err := strconv.ParseInt(req.Id, 10, 64)
	if err != nil || userID <= 0 {
		return nil, errx.BizErr("用户不存在")
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetTeamDetail(l.ctx, userID)
	if err != nil {
		return nil, err
	}
	return &types.MemberTeamDetailResp{
		Id:            dal.IDStr(row.ID),
		Username:      row.Username,
		AgentLevel:    int64(row.AgentLevel),
		WalletCount:   row.WalletCount,
		TotalAssets:   row.TotalAssets,
		TotalDeposit:  row.TotalDeposit,
		TotalWithdraw: row.TotalWithdraw,
		CreatedAt:     dal.FormatFbTimeVal(row.CreatedAt),
	}, nil
}
