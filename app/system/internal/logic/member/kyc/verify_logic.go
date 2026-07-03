// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package kyc

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// VerifyLogic 实名认证审核（对齐 Java updateVerify）
type VerifyLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewVerifyLogic(ctx context.Context, svcCtx *svc.ServiceContext) *VerifyLogic {
	return &VerifyLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *VerifyLogic) Verify(req *types.MemberKycVerifyReq) error {
	id, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	if err != nil || id <= 0 {
		return errx.BizErr("认证记录不存在")
	}
	return l.svcCtx.Dal.FbMemberDal.VerifyKyc(l.ctx, id, req.State, req.Remark)
}
