// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package wallet

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 用户钱包列表分页
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

// PageSet 分页查询 fb_user_wallets 并联用户信息（对齐 Java selectPageWithUser）
func (l *PageSetLogic) PageSet(req *types.PageSetMemberWalletReq) (resp *types.PageSetMemberWalletResp, err error) {
	q := dal.WalletPageQuery{
		Keyword:      req.Keyword,
		UserId:       req.UserId,
		AccountType:  req.AccountType,
		Status:       req.Status,
		Verified:     req.Verified,
		Username:     req.Username,
		Mobile:       req.Mobile,
		RealName:     req.RealName,
		Currency:     req.Currency,
		FrozenStatus: req.FrozenStatus,
		BeginTime:    req.BeginTime,
		EndTime:      req.EndTime,
		PageNum:      req.PageNum,
		PageSize:     req.PageSize,
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageWallets(l.ctx, q)
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberWalletItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.MemberWalletItem{
			Id:           dal.IDStr(r.ID),
			UserId:       dal.IDStr(r.UserID),
			Username:     r.Username,
			Mobile:       r.Mobile,
			RealName:     r.RealName,
			AccountType:  r.AccountType,
			Balance:      r.Balance,
			FrozenAmount: r.FrozenAmount,
			Frozen:       r.Frozen,
			Version:      dal.IDStr(r.Version),
			Currency:     r.Currency,
			DrawTicket:   int64(r.DrawTicket),
			CreatedAt:    dal.FormatFbTimeVal(r.CreatedAt),
			UpdatedAt:    dal.FormatFbTimeVal(r.UpdatedAt),
		})
	}
	return &types.PageSetMemberWalletResp{Rows: items, Total: total}, nil
}
