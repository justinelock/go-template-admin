// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package loginLog

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 登录记录分页
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

// PageSet 分页查询 fb_device_login_log
func (l *PageSetLogic) PageSet(req *types.PageSetMemberLoginLogReq) (resp *types.PageSetMemberLoginLogResp, err error) {
	f := dal.MemberListFilter{
		Keyword:   req.Keyword,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageLoginLogs(l.ctx, f, req.LoginResult, req.LoginMethod, req.RiskLevel)
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberLoginLogItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.MemberLoginLogItem{
			Id:            dal.IDStr(r.ID),
			UserId:        dal.IDStr(r.UserID),
			Username:      r.Username,
			RealName:      r.RealName,
			DeviceId:      r.DeviceID,
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
	return &types.PageSetMemberLoginLogResp{Rows: items, Total: total}, nil
}
