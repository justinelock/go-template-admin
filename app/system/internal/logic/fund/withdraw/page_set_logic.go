// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package withdraw

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 提现管理分页（对齐 Java FbWithdrawsServiceImpl.getPageData）
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

func (l *PageSetLogic) PageSet(req *types.PageSetFundWithdrawReq) (resp *types.PageSetFundWithdrawResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageWithdraws(l.ctx, dal.WithdrawPageQuery{
		Status:    req.Status,
		Type:      req.Type,
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
	items := make([]*types.FundWithdrawItem, 0, len(rows))
	for _, r := range rows {
		item := &types.FundWithdrawItem{
			Id:            dal.IDStr(r.ID),
			UserId:        dal.IDStr(r.UserID),
			Username:      r.Username,
			Mobile:        r.Mobile,
			RealName:      r.RealName,
			OrderNo:       r.OrderNo,
			Amount:        r.Amount,
			Status:        r.Status,
			WithdrawType:  r.WithdrawType,
			BankName:      r.BankName,
			BankCardNo:    r.BankCardNo,
			AccountName:   r.AccountName,
			PaymentStatus: r.PaymentStatus,
			PaymentNo:     r.PaymentNo,
			Remark:        r.Remark,
			RejectReason:  r.RejectReason,
			CreatedAt:     dal.FormatFbTimeVal(r.CreatedAt),
			UpdatedAt:     dal.FormatFbTimeVal(r.UpdatedAt),
		}
		if r.PaymentTime != nil {
			item.PaymentTime = dal.FormatFbTimeVal(*r.PaymentTime)
		}
		items = append(items, item)
	}
	return &types.PageSetFundWithdrawResp{Rows: items, Total: total}, nil
}
