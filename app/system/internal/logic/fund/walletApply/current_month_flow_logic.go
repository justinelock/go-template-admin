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
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// CurrentMonthFlowLogic 钱包申请-当月流水全量（对齐 Java getCurrentMonthList）
type CurrentMonthFlowLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewCurrentMonthFlowLogic(ctx context.Context, svcCtx *svc.ServiceContext) *CurrentMonthFlowLogic {
	return &CurrentMonthFlowLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *CurrentMonthFlowLogic) CurrentMonthFlow(req *types.FundWalletApplyCurrentMonthFlowReq) (resp *types.FundWalletApplyCurrentMonthFlowResp, err error) {
	userID, err := strconv.ParseInt(strings.TrimSpace(req.UserId), 10, 64)
	if err != nil || userID <= 0 {
		return nil, errx.BizErr("用户ID不能为空")
	}
	rows, err := l.svcCtx.Dal.FbMemberDal.ListCurrentMonthFlowDetails(l.ctx, userID)
	if err != nil {
		return nil, err
	}
	items := make([]*types.FundWalletApplyFlowItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.FundWalletApplyFlowItem{
			Id:           dal.IDStr(r.ID),
			UserId:       dal.IDStr(r.UserID),
			AccountType:  r.AccountType,
			FlowType:     r.FlowType,
			BeforeAmount: r.BeforeAmount,
			FlowAmount:   r.FlowAmount,
			AfterAmount:  r.AfterAmount,
			BusinessNo:   r.BusinessNo,
			Remark:       r.Remark,
			CreatedAt:    dal.FormatFbTimeVal(r.CreatedAt),
			WalletId:     dal.IDStr(r.WalletID),
			Currency:     r.Currency,
			Description:  r.Description,
			Status:       r.Status,
			UpdatedAt:    dal.FormatFbTime(r.UpdatedAt),
		})
	}
	return &types.FundWalletApplyCurrentMonthFlowResp{
		Rows:  items,
		Total: int64(len(items)),
	}, nil
}
