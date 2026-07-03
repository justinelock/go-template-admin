// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// DirectionLogic 修改合约订单交易方向（对齐 Java updateDirection）
type DirectionLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDirectionLogic(ctx context.Context, svcCtx *svc.ServiceContext) *DirectionLogic {
	return &DirectionLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *DirectionLogic) Direction(req *types.TradeContractDirectionReq) error {
	id, err := parseContractOrderID(req.Id)
	if err != nil {
		return err
	}
	return l.svcCtx.Dal.FbMemberDal.UpdateContractDirection(l.ctx, id, req.Direction)
}
