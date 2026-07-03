// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package news

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

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

func (l *InfoLogic) Info(req *types.IdReq) (resp *types.NotifyNewsItem, err error) {
	id, err := dal.ParseMarketNewsID(req.Id)
	if err != nil {
		return nil, err
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetMarketNewsByID(l.ctx, id)
	if err != nil {
		return nil, err
	}
	if row == nil {
		return nil, errx.BizErr("新闻不存在")
	}
	return mapNewsToItem(*row), nil
}
