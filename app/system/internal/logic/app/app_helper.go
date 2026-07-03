package app

import (
	"context"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/toolkit/auth"
	"ovra/toolkit/upload"
)

// ResolveOperator 解析当前操作人用户名，无登录信息时返回 system
func ResolveOperator(ctx context.Context, svcCtx *svc.ServiceContext) string {
	userID := strings.TrimSpace(auth.GetUserId(ctx))
	if userID == "" {
		return "system"
	}
	row, err := svcCtx.Dal.SysUserDal.SelectById(ctx, userID)
	if err != nil || row == nil {
		return userID
	}
	if strings.TrimSpace(row.UserName) != "" {
		return row.UserName
	}
	return userID
}

// ReleaseUploadSettings 将 system 配置转为 upload 包结构
func ReleaseUploadSettings(svcCtx *svc.ServiceContext) upload.AppReleaseUploadSettings {
	cfg := svcCtx.Config.AppReleaseUpload
	return upload.AppReleaseUploadSettings{
		WwwrootBase:    cfg.WwwrootBase,
		SubPath:        cfg.SubPath,
		UrlScheme:      cfg.UrlScheme,
		DefaultDomain:  cfg.DefaultDomain,
		AllowedDomains: cfg.AllowedDomains,
	}
}
