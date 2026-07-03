// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// InfoLogic 投信产品详情（对齐 Java GET /fubang/fund/{id}）
type InfoLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewInfoLogic(ctx context.Context, svcCtx *svc.ServiceContext) *InfoLogic {
	return &InfoLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *InfoLogic) Info(req *types.IdReq) (*types.InvestListItem, error) {
	id, err := dal.ParseFundID(req.Id)
	if err != nil {
		return nil, err
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetFundByID(l.ctx, id)
	if err != nil {
		return nil, err
	}
	if row == nil {
		return nil, errx.BizErr("投信产品不存在")
	}
	return mapFundToItem(*row), nil
}
