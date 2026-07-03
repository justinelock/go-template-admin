package sse

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type SendLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSendLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SendLogic {
	return &SendLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Send 演示接口：记录单用户消息，不实际推送 SSE
func (l *SendLogic) Send(req *types.SseSendReq) error {
	l.Infof("[dev/sse] send userId=%q message=%q", req.UserId, req.Message)
	return nil
}
