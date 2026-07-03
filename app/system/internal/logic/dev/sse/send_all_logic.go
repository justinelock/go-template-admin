package sse

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type SendAllLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSendAllLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SendAllLogic {
	return &SendAllLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// SendAll 演示接口：记录广播消息，不实际推送 SSE（长连接未实现）
func (l *SendAllLogic) SendAll(req *types.SseSendReq) error {
	l.Infof("[dev/sse] broadcast message=%q", req.Message)
	return nil
}
