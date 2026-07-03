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

// InfoLogic 按 id 返回业务用户完整详情（MemberUserInfoResp）
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

func (l *InfoLogic) Info(req *types.IdReq) (resp *types.MemberUserInfoResp, err error) {
	row, err := l.svcCtx.Dal.FbMemberDal.GetUserInfo(l.ctx, req.Id)
	if err != nil {
		return nil, err
	}
	// 与列表行一致：Redis 计算 onlineStatus
	onlineMap := l.svcCtx.Dal.FbUserRedisDal.BatchOnlineStatus(l.ctx, []int64{row.ID})
	resp = mapUserInfoRow(row, onlineMap[row.ID])
	return resp, nil
}

// mapUserInfoRow 将 DAL 行映射为 API 详情实体
func mapUserInfoRow(row *dal.MemberUserInfoRow, onlineStatus int64) *types.MemberUserInfoResp {
	if row == nil {
		return nil
	}
	parentID := ""
	if row.ParentID > 0 {
		parentID = dal.IDStr(row.ParentID)
	}
	info := &types.MemberUserInfoResp{
		Id:                     dal.IDStr(row.ID),
		Username:               row.Username,
		Email:                  row.Email,
		Mobile:                 row.Mobile,
		Phone:                  row.Phone,
		RealName:               row.RealName,
		IdCard:                 row.IDCard,
		VerificationStatus:     row.VerificationStatus,
		Verified:               row.Verified,
		CreditScore:            int64(row.CreditScore),
		SecurityQuestion:       row.SecurityQuestion,
		SecurityAnswer:         row.SecurityAnswer,
		Role:                   row.Role,
		AccountLocked:          row.AccountLocked,
		FailedAttempts:         int64(row.FailedAttempts),
		LastLogin:              dal.FormatFbTime(row.LastLogin),
		ParentId:               parentID,
		Level:                  int64(row.Level),
		AgentLevel:             int64(row.AgentLevel),
		InviteCode:             row.InviteCode,
		CommissionRate:         row.CommissionRate,
		TotalCommission:        row.TotalCommission,
		TeamSize:               int64(row.TeamSize),
		Status:                 row.Status,
		ContractControl:        int64(row.ContractControl),
		IsOnline:               row.IsOnline,
		Remark:                 row.Remark,
		Flag:                   int64(row.Flag),
		IsTest:                 row.IsTest,
		HasPassword:            row.HasPassword,
		HasPayPassword:         row.HasPayPassword,
		PayPasswordUpdatedAt:   dal.FormatFbTime(row.PayPasswordUpdatedAt),
		PayPasswordErrorCount:  int64(row.PayPasswordErrorCount),
		PayPasswordLockedUntil: dal.FormatFbTime(row.PayPasswordLockedUntil),
		Avatar:                 row.Avatar,
		TotalBalance:           row.TotalBalance,
		FundPositionAmount:     row.FundPositionAmount,
		FundPositionDividend:   row.FundPositionDividend,
		OnlineStatus:           onlineStatus,
		CreatedAt:              dal.FormatFbTimeVal(row.CreatedAt),
		UpdatedAt:              dal.FormatFbTime(row.UpdatedAt),
	}
	if row.ParentID > 0 {
		info.Parent = &types.MemberUserParentBrief{
			Id:       parentID,
			Username: row.ParentUsername,
			RealName: row.ParentRealName,
		}
	}
	return info
}
