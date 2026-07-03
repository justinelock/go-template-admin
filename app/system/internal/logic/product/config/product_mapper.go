package config

import (
	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/types"
)

// mapProductToItem 将 DAL FundProductVO 映射为 API ProductConfigItem
func mapProductToItem(r dal.FundProductVO) *types.ProductConfigItem {
	item := &types.ProductConfigItem{
		Id:                dal.IDStr(r.ID),
		Code:              r.Code,
		Alias:             r.Alias,
		TradePair:         r.TradePair,
		Name:              r.Name,
		Type:              r.Type,
		Market:            r.Market,
		TradingHours:      r.TradingHours,
		Description:       r.Description,
		Status:            r.Status,
		DividendRatio:     r.DividendRatio,
		Currency:          r.Currency,
		Period:            r.Period,
		TotalDividendRate: r.TotalDividendRate,
		DailyDividendRate: r.DailyDividendRate,
		IsLocked:          r.IsLocked,
		LimitBuyCount:     r.LimitBuyCount,
		LimitSellDays:     r.LimitSellDays,
		LimitBuyAmount:    r.LimitBuyAmount,
		Sort:              r.Sort,
		Odds:              r.Odds,
		CreateTime:        dal.FormatFbTimeVal(r.CreateTime),
		UpdateTime:        dal.FormatFbTimeVal(r.UpdateTime),
	}
	if r.DividendEndDate != nil {
		item.DividendEndDate = dal.FormatFbDatePtr(r.DividendEndDate)
	}
	if r.DividendStrDate != nil {
		item.DividendStrDate = dal.FormatFbDatePtr(r.DividendStrDate)
	}
	return item
}

func saveReqToInput(req *types.ProductConfigSaveReq) dal.FundProductSaveInput {
	return dal.FundProductSaveInput{
		Code:         req.Code,
		Alias:        req.Alias,
		TradePair:    req.TradePair,
		Name:         req.Name,
		Type:         req.Type,
		Market:       req.Market,
		TradingHours: req.TradingHours,
		Description:  req.Description,
		Status:       req.Status,
		Currency:     req.Currency,
		Odds:         req.Odds,
		Sort:         req.Sort,
	}
}
