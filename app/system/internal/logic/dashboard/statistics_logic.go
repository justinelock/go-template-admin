// 分析页仪表盘统计（对齐 Java DashboardController.getStatistics）
package dashboard

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type StatisticsLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewStatisticsLogic(ctx context.Context, svcCtx *svc.ServiceContext) *StatisticsLogic {
	return &StatisticsLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *StatisticsLogic) Statistics(req *types.DashboardStatisticsQuery) (resp *types.DashboardStatisticsResp, err error) {
	// 1. 解析 type 与时间范围
	statType := dal.ResolveStatisticsType(req.Type)
	start, end := dal.ResolveDateRange(statType)

	memberDal := l.svcCtx.Dal.FbMemberDal

	// 2. 实名认证：按 status 分组计数
	statUserMap, err := memberDal.CountIdentityVerifyByStatus(l.ctx, start, end)
	if err != nil {
		return nil, err
	}

	// 3. 钱包申请：按 status 去重 user_id 计数
	statUserWalletMap, err := memberDal.CountWalletApplyDistinctUserByStatus(l.ctx, start, end)
	if err != nil {
		return nil, err
	}

	// 4. 充值：PENDING 条数 + 成功金额
	statDeposit, err := memberDal.AggregateDeposits(l.ctx, start, end)
	if err != nil {
		return nil, err
	}

	// 5. 提现：PENDING 条数 + 成功金额
	statWithdraw, err := memberDal.AggregateWithdraws(l.ctx, start, end)
	if err != nil {
		return nil, err
	}

	// 6. 组装响应（字段名与 Java data.put 一一对应）
	resp = &types.DashboardStatisticsResp{
		Type:                    int64(statType),
		PendingUserCount:        dal.MapCountOrZero(statUserMap, dal.VerifyStatusPending),
		ApprovedUserCount:       dal.MapCountOrZero(statUserMap, dal.VerifyStatusApproved),
		VerifiedUserCount:       dal.MapCountOrZero(statUserMap, dal.VerifyStatusVerified),
		RejectedUserCount:       dal.MapCountOrZero(statUserMap, dal.VerifyStatusRejected),
		PendingUserWalletCount:  dal.MapCountOrZero(statUserWalletMap, dal.VerifyStatusPending),
		ApprovedUserWalletCount: dal.MapCountOrZero(statUserWalletMap, dal.VerifyStatusApproved),
		RejectedUserWalletCount: dal.MapCountOrZero(statUserWalletMap, dal.VerifyStatusRejected),
		DepositCount:            statDeposit.PendingCount,
		DepositSum:              dal.RoundFundSum(statDeposit.SuccessSum),
		WithdrawCount:           statWithdraw.PendingCount,
		WithdrawSum:             dal.RoundFundSum(statWithdraw.SuccessSum),
	}
	return resp, nil
}
