package encrypt

import (
	"context"
	"time"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type ResponseLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewResponseLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ResponseLogic {
	return &ResponseLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Response 返回示例 JSON；请求携带 encrypt-key 时由全局中间件加密响应体
func (l *ResponseLogic) Response() (*types.EncryptDemoResp, error) {
	return &types.EncryptDemoResp{
		Plain:   time.Now().Format(time.RFC3339),
		Message: "Ovra-Zero API 加解密演示：POST /request 测请求加密，本接口测响应加密（需携带 encrypt-key）",
	}, nil
}
