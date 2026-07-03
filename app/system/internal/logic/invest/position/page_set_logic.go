// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package position

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 持仓订单分页（对齐 Java FbFundPositionServiceImpl.getPageData）
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

func (l *PageSetLogic) PageSet(req *types.PageSetInvestPositionReq) (resp *types.PageSetInvestPositionResp, err error) {
	// 组装筛选条件，查 fb_fund_position 分页
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageFundPositions(l.ctx, dal.FundPositionPageQuery{
		Keyword:   req.Keyword,
		FundCode:  req.FundCode,
		Status:    req.Status,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	// 映射为 API 契约字段（日期格式化、id 转 string）
	items := make([]*types.InvestPositionItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.InvestPositionItem{
			Id:             dal.IDStr(r.ID),
			UserId:         dal.IDStr(r.UserID),
			Username:       r.Username,
			Mobile:         r.Mobile,
			RealName:       r.RealName,
			FundCode:       r.FundCode,
			FundName:       r.FundName,
			Amount:         r.Amount,
			BuyDate:        dal.FormatFbDateOnly(r.BuyDate),
			StartDate:      dal.FormatFbDatePtr(r.StartDate),
			EndDate:        dal.FormatFbDatePtr(r.EndDate),
			Period:         r.Period,
			Rate:           r.Rate,
			Profit:         r.Profit,
			State:          r.State,
			Status:         r.Status,
			LastProfitDate: dal.FormatFbDatePtr(r.LastProfitDate),
			CreateTime:     dal.FormatFbTimeVal(r.CreateTime),
			UpdateTime:     dal.FormatFbTimeVal(r.UpdateTime),
		})
	}
	return &types.PageSetInvestPositionResp{Rows: items, Total: total}, nil
}
