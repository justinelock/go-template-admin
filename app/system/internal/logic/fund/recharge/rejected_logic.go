// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package recharge

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// RejectedLogic 拒绝充值（对齐 Java updateRejected）
type RejectedLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewRejectedLogic(ctx context.Context, svcCtx *svc.ServiceContext) *RejectedLogic {
	return &RejectedLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *RejectedLogic) Rejected(req *types.FundRechargeRejectReq) error {
	id, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	if err != nil || id <= 0 {
		return errx.BizErr("充值订单不存在")
	}
	return l.svcCtx.Dal.FbMemberDal.RejectDeposit(l.ctx, id, req.Remark)
}
