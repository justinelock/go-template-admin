// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package report

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// FlowLogic 用户流水明细分页
type FlowLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewFlowLogic(ctx context.Context, svcCtx *svc.ServiceContext) *FlowLogic {
	return &FlowLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Flow 按 userId 分页查询 fb_account_flow_records（对齐 Java selectPageWithUser）
func (l *FlowLogic) Flow(req *types.PageSetMemberReportFlowReq) (resp *types.PageSetMemberReportFlowResp, err error) {
	q := dal.AccountFlowPageQuery{
		UserID:    req.UserId,
		Status:    req.Status,
		FlowType:  req.Type,
		Keyword:   req.Keyword,
		Username:  req.Username,
		Mobile:    req.Mobile,
		RealName:  req.RealName,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageAccountFlow(l.ctx, q)
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberReportFlowItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.MemberReportFlowItem{
			Id:           dal.IDStr(r.ID),
			UserId:       dal.IDStr(r.UserID),
			Username:     r.Username,
			Mobile:       r.Mobile,
			RealName:     r.RealName,
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
	return &types.PageSetMemberReportFlowResp{Rows: items, Total: total}, nil
}
