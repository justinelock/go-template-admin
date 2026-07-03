// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package statement

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 账户流水分页（对齐 Java FbAccountFlowRecordsServiceImpl.getPageData）
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

func (l *PageSetLogic) PageSet(req *types.PageSetFundStatementReq) (resp *types.PageSetFundStatementResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageAccountFlow(l.ctx, dal.AccountFlowPageQuery{
		UserID:    req.UserId,
		Status:    req.Status,
		FlowType:  req.Type,
		Currency:  req.Currency,
		Keyword:   req.Keyword,
		Username:  req.Username,
		Mobile:    req.Mobile,
		RealName:  req.RealName,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	items := make([]*types.FundStatementItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.FundStatementItem{
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
	return &types.PageSetFundStatementResp{Rows: items, Total: total}, nil
}
