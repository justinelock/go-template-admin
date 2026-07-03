package list

import (
	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/types"
)

// mapFundToItem 将 DAL FundVO 映射为 API InvestListItem
func mapFundToItem(r dal.FundVO) *types.InvestListItem {
	item := &types.InvestListItem{
		Id:                 dal.IDStr(r.ID),
		Code:               r.Code,
		Symbol:             r.Symbol,
		Name:               r.Name,
		Company:            r.Company,
		Ev:                 r.Ev,
		Price:              r.Price,
		Currency:           r.Currency,
		Description:        r.Description,
		Poster:             r.Poster,
		Status:             r.Status,
		SoldOut:            r.SoldOut,
		RateMin:            r.RateMin,
		RateMax:            r.RateMax,
		Rate:               r.Rate,
		MinAmount:          r.MinAmount,
		MinAppendAmount:    r.MinAppendAmount,
		MaxAmount:          r.MaxAmount,
		Period:             r.Period,
		RateMode:           r.RateMode,
		LatestAmountRaised: r.LatestAmountRaised,
		Sort:               r.Sort,
		CreateTime:         dal.FormatFbTimeVal(r.CreateTime),
		UpdateTime:         dal.FormatFbTimeVal(r.UpdateTime),
	}
	if r.LastestFundingDate != nil {
		item.LastestFundingDate = dal.FormatFbDatePtr(r.LastestFundingDate)
	}
	return item
}

// saveReqToInput 将保存请求转为 DAL 写入结构
func saveReqToInput(req *types.InvestListSaveReq) (dal.FundSaveInput, error) {
	fundDate, err := dal.ParseFundDate(req.LastestFundingDate)
	if err != nil {
		return dal.FundSaveInput{}, err
	}
	in := dal.FundSaveInput{
		Code:               req.Code,
		Symbol:             req.Symbol,
		Name:               req.Name,
		Company:            req.Company,
		Ev:                 req.Ev,
		Price:              req.Price,
		Currency:           req.Currency,
		Description:        req.Description,
		Status:             req.Status,
		SoldOut:            req.SoldOut,
		RateMin:            req.RateMin,
		RateMax:            req.RateMax,
		Rate:               req.Rate,
		MinAmount:          req.MinAmount,
		MinAppendAmount:    req.MinAppendAmount,
		MaxAmount:          req.MaxAmount,
		Period:             req.Period,
		RateMode:           req.RateMode,
		LatestAmountRaised: req.LatestAmountRaised,
		LastestFundingDate: fundDate,
		Sort:               req.Sort,
	}
	if req.Status != 0 && req.Status != 1 {
		in.Status = 1
	}
	return in, nil
}
