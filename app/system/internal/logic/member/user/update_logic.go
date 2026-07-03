// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package user

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// UpdateLogic 保存业务用户编辑
type UpdateLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdateLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateLogic {
	return &UpdateLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UpdateLogic) Update(req *types.MemberUserUpdateReq) error {
	return l.svcCtx.Dal.FbMemberDal.UpdateUser(l.ctx, req.Id, dal.MemberUserUpdate{
		Username:           req.Username,
		Password:           req.Password,
		PayPassword:        req.PayPassword,
		RealName:           req.RealName,
		Mobile:             req.Mobile,
		Email:              req.Email,
		IDCard:             req.IdCard,
		SecurityQuestion:   req.SecurityQuestion,
		SecurityAnswer:     req.SecurityAnswer,
		ParentID:           req.ParentId,
		InviteCode:         req.InviteCode,
		CommissionRate:     req.CommissionRate,
		TotalCommission:    req.TotalCommission,
		CreditScore:        req.CreditScore,
		VerificationStatus: req.VerificationStatus,
		AccountLocked:      req.AccountLocked,
		Status:             req.Status,
		Verified:           req.Verified,
		ContractControl:    req.ContractControl,
		Remark:             req.Remark,
		Avatar:             req.Avatar,
	})
}
