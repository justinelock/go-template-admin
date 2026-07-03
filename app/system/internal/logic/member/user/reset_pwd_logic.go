// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package user

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// ResetPwdLogic 业务用户重置登录/交易密码
type ResetPwdLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewResetPwdLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ResetPwdLogic {
	return &ResetPwdLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// ResetPwd type=1 登录密码，type=2 交易密码；password 空则默认 123456
func (l *ResetPwdLogic) ResetPwd(req *types.MemberUserResetPwdReq) error {
	return l.svcCtx.Dal.FbMemberDal.ResetUserPassword(l.ctx, req.Id, req.Password, req.Type)
}
