// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 合约订单分页（对齐 Java FbContractOrdersServiceImpl.getPageData）
type PageSetLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewPageSetLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PageSetLogic {
	return &PageSetLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *PageSetLogic) PageSet(req *types.PageSetTradeContractReq) (resp *types.PageSetTradeContractResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageContractOrders(l.ctx, dal.ContractOrderPageQuery{
		Keyword:       req.Keyword,
		Status:        req.Status,
		ControlResult: req.ControlResult,
		BeginTime:     req.BeginTime,
		EndTime:       req.EndTime,
		PageNum:       req.PageNum,
		PageSize:      req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	items := make([]*types.TradeContractItem, 0, len(rows))
	for _, r := range rows {
		item := &types.TradeContractItem{
			Id:            dal.IDStr(r.ID),
			UserId:        dal.IDStr(r.UserID),
			Username:      r.Username,
			Mobile:        r.Mobile,
			RealName:      r.RealName,
			Account:       r.Account,
			CoinType:      r.CoinType,
			Market:        r.Market,
			Direction:     r.Direction,
			TradePair:     r.TradePair,
			PairName:      r.PairName,
			ProductName:   r.ProductName,
			Amount:        r.Amount,
			ProfitRatio:   r.ProfitRatio,
			Seconds:       r.Seconds,
			OpeningPrice:  r.OpeningPrice,
			Balance:       r.Balance,
			Status:        r.Status,
			Remark:        r.Remark,
			CreateTime:    dal.FormatFbTimeVal(r.CreateTime),
			UpdateTime:    dal.FormatFbTimeVal(r.UpdateTime),
			Version:       r.Version,
			HasBoughtFund: r.HasBoughtFund,
		}
		if r.ClosingPriceSet {
			item.ClosingPrice = r.ClosingPrice
		}
		item.OpeningTime = dal.FormatFbTimeVal(r.OpeningTime)
		if r.ClosingTimeSet {
			item.ClosingTime = dal.FormatFbTimeVal(r.ClosingTime)
		}
		if r.ExpectedProfitSet {
			item.ExpectedProfit = r.ExpectedProfit
		}
		if r.ActualProfitSet {
			item.ActualProfit = r.ActualProfit
		}
		if r.WalletBalanceAfterSettleSet {
			item.WalletBalanceAfterSettle = r.WalletBalanceAfterSettle
		}
		if r.ControlTypeSet {
			item.ControlType = r.ControlType
		}
		if r.ControlResultSet {
			item.ControlResult = r.ControlResult
		}
		if r.UserControlSet {
			item.UserControl = r.UserControl
		}
		item.GlobalControlStateSnapshot = r.GlobalControlStateSnapshot
		if r.GlobalControlAppliedSet {
			item.GlobalControlApplied = r.GlobalControlApplied
		}
		items = append(items, item)
	}
	return &types.PageSetTradeContractResp{Rows: items, Total: total}, nil
}
