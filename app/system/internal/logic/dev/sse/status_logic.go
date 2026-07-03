package sse

import (
	"context"

	"ovra/app/system/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type StatusLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewStatusLogic(ctx context.Context, svcCtx *svc.ServiceContext) *StatusLogic {
	return &StatusLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Status Ovra-Zero 暂未接入 /resource/sse 长连接，演示接口固定返回 false
func (l *StatusLogic) Status() (bool, error) {
	return false, nil
}
