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

type SettlementDetailLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSettlementDetailLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SettlementDetailLogic {
	return &SettlementDetailLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *SettlementDetailLogic) SettlementDetail(req *types.IdReq) (resp *types.TradeContractSettlementDetailResp, err error) {
	orderID, err := parseContractOrderID(req.Id)
	if err != nil {
		return nil, err
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetContractOrderSettlementDetail(l.ctx, orderID)
	if err != nil {
		return nil, err
	}
	return &types.TradeContractSettlementDetailResp{
		Id:      dal.IDStr(row.ID),
		OrderId: dal.IDStr(row.OrderID),
		UserId:  dal.IDStr(row.UserID),
		Detail:  row.Remark,
	}, nil
}
