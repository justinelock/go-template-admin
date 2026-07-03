// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package wallet

import (
	"context"
	"math"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

type AddOrSubtractLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAddOrSubtractLogic(ctx context.Context, svcCtx *svc.ServiceContext) *AddOrSubtractLogic {
	return &AddOrSubtractLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// AddOrSubtract 管理端加减款，对齐 Java PUT /fubang/fbuserwallets/addOrSubtract
func (l *AddOrSubtractLogic) AddOrSubtract(req *types.MemberWalletAddOrSubtractReq) error {
	walletID, err := dal.ParseWalletID(req.Id)
	if err != nil {
		return err
	}
	amount := math.Abs(req.Amount)
	if amount <= 0 {
		return errx.BizErr("金额必须大于0")
	}
	flowType, err := dal.NormalizeAddOrSubtractFlowType(req.Type, req.FlowType)
	if err != nil {
		return err
	}
	remark := strings.TrimSpace(req.Remark)
	if remark == "" {
		if req.Type {
			remark = "后台调整加款"
		} else {
			remark = "后台调整减款"
		}
	}
	d := l.svcCtx.Dal.FbUserWalletDal
	if req.Type {
		return d.AddBalance(l.ctx, walletID, amount, remark, flowType)
	}
	return d.ReduceBalance(l.ctx, walletID, amount, remark, flowType)
}
