// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package walletApply

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/auth"

	"github.com/zeromicro/go-zero/core/logx"
)

// VerifyLogic 钱包申请审核（对齐 Java updateVerify）
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

func (l *VerifyLogic) Verify(req *types.FundWalletApplyVerifyReq) error {
	id, err := dal.ParseWalletApplyID(req.Id)
	if err != nil {
		return err
	}
	auditUserID, _ := strconv.ParseInt(strings.TrimSpace(auth.GetUserId(l.ctx)), 10, 64)
	return l.svcCtx.Dal.FbMemberDal.VerifyWalletApplication(
		l.ctx, id, req.State, req.Remark, auditUserID,
	)
}
