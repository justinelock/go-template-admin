package encrypt

import (
	"io"
	"net/http"
	"strings"

	"github.com/zeromicro/go-zero/rest/httpx"
	encryptlogic "ovra/app/system/internal/logic/dev/encrypt"
	"ovra/app/system/internal/svc"
)

func RequestHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// 1. 读取经 ApiEncrypt 中间件解密后的明文 body
		body, err := io.ReadAll(r.Body)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}
		plain := strings.TrimSpace(string(body))
		plain = strings.Trim(plain, "\"")

		// 2. 回显明文，前端在开发者工具对比加密前后数据
		l := encryptlogic.NewRequestLogic(r.Context(), svcCtx)
		resp, err := l.Request(plain)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}
		httpx.OkJsonCtx(r.Context(), w, resp)
	}
}
