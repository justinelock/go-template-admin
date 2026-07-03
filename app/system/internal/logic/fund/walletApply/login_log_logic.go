// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package walletApply

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// LoginLogLogic 钱包申请-登录记录
type LoginLogLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewLoginLogLogic(ctx context.Context, svcCtx *svc.ServiceContext) *LoginLogLogic {
	return &LoginLogLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *LoginLogLogic) LoginLog(req *types.PageSetFundWalletApplyLoginLogReq) (resp *types.PageSetFundWalletApplyLoginLogResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageWalletApplyLoginLogs(l.ctx, dal.WalletApplyLoginLogFilter{
		UserID:    req.UserId,
		Status:    req.Status,
		Keyword:   req.Keyword,
		Username:  req.Username,
		RealName:  req.RealName,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	items := make([]*types.FundWalletApplyLoginLogItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.FundWalletApplyLoginLogItem{
			Id:            dal.IDStr(r.ID),
			UserId:        dal.IDStr(r.UserID),
			Username:      r.Username,
			LoginTime:     dal.FormatFbTimeVal(r.LoginTime),
			LoginIp:       r.LoginIP,
			LoginLocation: r.LoginLocation,
			LoginType:     r.LoginType,
			LoginResult:   r.LoginResult,
			FailReason:    r.FailReason,
			RiskLevel:     r.RiskLevel,
			RiskDetail:    r.RiskDetail,
		})
	}
	return &types.PageSetFundWalletApplyLoginLogResp{Rows: items, Total: total}, nil
}
