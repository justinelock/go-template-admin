// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package walletApply

import (
	"context"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// DetailLogic 钱包申请详情（对齐 Java getDetail）
type DetailLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDetailLogic(ctx context.Context, svcCtx *svc.ServiceContext) *DetailLogic {
	return &DetailLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Detail 组装 basicInfo / securityInfo / loginStats / flowStats
func (l *DetailLogic) Detail(req *types.IdReq) (resp *types.FundWalletApplyDetailResp, err error) {
	memberDal := l.svcCtx.Dal.FbMemberDal
	appID, err := dal.ParseWalletApplyID(req.Id)
	if err != nil {
		return nil, err
	}
	app, err := memberDal.GetWalletApplicationByID(l.ctx, appID)
	if err != nil {
		return nil, err
	}
	user, err := memberDal.GetWalletApplyUserSecurity(l.ctx, app.UserID)
	if err != nil {
		return nil, err
	}
	identityVerified, err := memberDal.HasVerifiedIdentity(l.ctx, app.UserID)
	if err != nil {
		return nil, err
	}
	twoFactor := user.SecurityQuestion != "" && user.SecurityAnswer != ""
	bindEmail := strings.TrimSpace(user.Email) != ""
	securityScore := dal.CalcWalletApplySecurityScore(identityVerified, twoFactor, bindEmail)

	basic := &types.FundWalletApplyBasicInfo{
		Id:                  dal.IDStr(app.ID),
		Username:            user.Username,
		AccountType:         app.AccountType,
		RiskAssessmentScore: int64(app.RiskAssessmentScore),
		Status:              app.Status,
		ApplyTime:           dal.FormatFbTimeVal(app.ApplyTime),
		RejectReason:        app.RejectReason,
		Remark:              app.Remark,
	}
	if app.AuditTime != nil {
		basic.AuditTime = dal.FormatFbTimeVal(*app.AuditTime)
	}

	monthFlows, err := memberDal.ListCurrentMonthFlows(l.ctx, app.UserID)
	if err != nil {
		return nil, err
	}
	monthCount, income, expense, dailyAvg, successRate, typeMap := dal.BuildWalletApplyFlowStats(monthFlows)

	recentLogins, err := memberDal.ListRecentLoginLogs(l.ctx, app.UserID, 10)
	if err != nil {
		return nil, err
	}
	monthLoginCount, err := memberDal.CountCurrentMonthLogins(l.ctx, app.UserID)
	if err != nil {
		return nil, err
	}
	commonIP, commonArea, lastLogin := dal.PickCommonLoginIP(recentLogins)

	return &types.FundWalletApplyDetailResp{
		BasicInfo: basic,
		SecurityInfo: &types.FundWalletApplySecurityInfo{
			TwoFactorEnabled: twoFactor,
			SecurityScore:    securityScore,
			IdentityVerified: identityVerified,
		},
		LoginStats: &types.FundWalletApplyLoginStats{
			CommonLoginIp:   commonIP,
			LastLoginTime:   lastLogin,
			CommonLoginArea: commonArea,
			MonthLoginCount: monthLoginCount,
		},
		FlowStats: &types.FundWalletApplyFlowStats{
			TradeSuccessRate: successRate,
			MonthFlowCount:   monthCount,
			DailyAvgAmount:   dailyAvg,
			MonthIncome:      income,
			MonthExpense:     expense,
			TypeStatsMap:     typeMap,
		},
	}, nil
}
