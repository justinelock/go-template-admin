// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package position

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// OrderPageSetLogic 收益记录分页（按 userId + positionId 查 fb_fund_profit_log）
type OrderPageSetLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewOrderPageSetLogic(ctx context.Context, svcCtx *svc.ServiceContext) *OrderPageSetLogic {
	return &OrderPageSetLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *OrderPageSetLogic) OrderPageSet(req *types.PageSetInvestPositionOrderReq) (resp *types.PageSetInvestPositionOrderResp, err error) {
	userID, _ := strconv.ParseInt(strings.TrimSpace(req.UserId), 10, 64)
	positionID, _ := strconv.ParseInt(strings.TrimSpace(req.PositionId), 10, 64)
	// 按 userId + positionId 查 fb_fund_profit_log
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageFundProfitLogs(l.ctx, dal.FundProfitLogPageQuery{
		UserID:     userID,
		PositionID: positionID,
		PageNum:    req.PageNum,
		PageSize:   req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	// profit 字段对应 profit_amount
	items := make([]*types.InvestPositionOrderItem, 0, len(rows))
	for _, r := range rows {
		item := &types.InvestPositionOrderItem{
			Id:               dal.IDStr(r.ID),
			UserId:           dal.IDStr(r.UserID),
			PositionId:       dal.IDStr(r.PositionID),
			FundCode:         r.FundCode,
			ProfitDate:       dal.FormatFbDateOnly(r.ProfitDate),
			Profit:           r.ProfitAmount,
			CumulativeProfit: r.CumulativeProfit,
			Status:           r.Status,
		}
		if r.OrderID != nil && *r.OrderID > 0 {
			item.OrderId = dal.IDStr(*r.OrderID)
		}
		if r.ProfitDatetime != nil {
			item.ProfitDatetime = dal.FormatFbTimeVal(*r.ProfitDatetime)
		}
		if r.CreateTime != nil {
			item.CreateTime = dal.FormatFbTimeVal(*r.CreateTime)
		}
		if r.UpdateTime != nil {
			item.UpdateTime = dal.FormatFbTimeVal(*r.UpdateTime)
		}
		items = append(items, item)
	}
	return &types.PageSetInvestPositionOrderResp{Rows: items, Total: total}, nil
}
