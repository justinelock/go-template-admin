package encrypt

import (
	"context"

	"ovra/app/system/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type RequestLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewRequestLogic(ctx context.Context, svcCtx *svc.ServiceContext) *RequestLogic {
	return &RequestLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Request 回显经 ApiEncrypt 中间件解密后的请求体，供前端对比密文与明文
func (l *RequestLogic) Request(plain string) (string, error) {
	return plain, nil
}
