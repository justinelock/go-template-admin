// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// LoseLogic 合约订单控单-输（对齐 Java updateControl LOSE）
type LoseLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewLoseLogic(ctx context.Context, svcCtx *svc.ServiceContext) *LoseLogic {
	return &LoseLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *LoseLogic) Lose(req *types.IdReq) error {
	id, err := parseContractOrderID(req.Id)
	if err != nil {
		return err
	}
	return l.svcCtx.Dal.FbMemberDal.UpdateContractControl(l.ctx, id, 2)
}
