package middlewares

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"ovra/toolkit/auth"
	"ovra/toolkit/ip"
	"ovra/toolkit/tenant"
	"ovra/toolkit/utils"
	"strings"

	"github.com/zeromicro/go-zero/core/stores/redis"
)

// writeUnauthorized 返回与 RuoYi/Vben 一致的业务 JSON（code=401，HTTP 200），
// 前端据此执行登出并跳转登录页；勿用 http.Error 返回裸 401 文本。
func writeUnauthorized(w http.ResponseWriter, msg string) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	_ = json.NewEncoder(w).Encode(map[string]any{
		"code": http.StatusUnauthorized,
		"msg":  msg,
	})
}

func ExecHandle(next http.HandlerFunc, accessSecret string, rds *redis.Redis, multipleLoginDevices bool) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		authorization := r.Header.Get("Authorization")
		if authorization == "" {
			writeUnauthorized(w, "未登录或登录已过期")
			return
		}
		tokenString := strings.TrimPrefix(authorization, "Bearer ")
		uc, err := auth.AnalyseToken(tokenString, accessSecret)
		if err != nil {
			writeUnauthorized(w, "登录认证无效，请重新登录")
			return
		}
		authInstance := auth.NewAuth(rds, &uc.UserInfo)
		key := ""
		if multipleLoginDevices {
			ipStr, ua := ip.GetIPUa(r)
			name, version := ua.Browser()
			authMd5 := utils.AuthMd5(ipStr, name, version, ua.OS())
			key = fmt.Sprintf(auth.TokenKeyMd5, uc.ClientId, uc.UserId, authMd5)
		} else {
			key = fmt.Sprintf(auth.TokenKey, uc.ClientId, uc.UserId)
		}
		expired, err := authInstance.CheckToken(r.Context(), key, tokenString)
		if err != nil {
			writeUnauthorized(w, "登录认证无效，请重新登录")
			return
		}
		if expired {
			writeUnauthorized(w, "登录认证过期，请重新登录后继续")
			return
		}
		tenantId, err := tenant.GetTenantId(r.Context(), rds, &uc.UserInfo)
		if err != nil {
			writeUnauthorized(w, "登录认证无效，请重新登录")
			return
		}
		r.Header.Set(auth.UserIDKey, uc.UserId)
		r.Header.Set(auth.TenantIDKey, tenantId)
		r.Header.Set(auth.ClientIDKey, uc.ClientId)
		ctx := context.WithValue(r.Context(), auth.UserIDKey, uc.UserId)
		ctx = context.WithValue(ctx, auth.TenantIDKey, tenantId)
		ctx = context.WithValue(ctx, auth.ClientIDKey, uc.ClientId)
		next(w, r.WithContext(ctx))
	}
}
