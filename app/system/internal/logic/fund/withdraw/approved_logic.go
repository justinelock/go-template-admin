// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package withdraw

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// ApprovedLogic 批准提现（对齐 Java updateApproved）
type ApprovedLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewApprovedLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ApprovedLogic {
	return &ApprovedLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *ApprovedLogic) Approved(req *types.IdReq) error {
	id, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	if err != nil || id <= 0 {
		return errx.BizErr("提现订单不存在")
	}
	return l.svcCtx.Dal.FbMemberDal.ApproveWithdraw(l.ctx, id)
}
