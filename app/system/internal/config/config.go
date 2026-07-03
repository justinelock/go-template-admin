package config

import (
	"ovra/toolkit/configshared"

	"github.com/zeromicro/go-zero/rest"
)

type Config struct {
	RestConf    rest.RestConf
	Tenant      configshared.TenantConfig
	Data        configshared.DataConfig
	JwtAuth     configshared.JwtAuthConfig
	ApiDecrypt  configshared.ApiDecryptConfig
	Captcha     configshared.CaptchaConfig
	Idempotency configshared.IdempotencyConfig
	Sign        configshared.SignConfig
	FileUpload        FileUploadConfig
	AppReleaseUpload  AppReleaseUploadConfig
}

// FileUploadConfig 本地文件上传根目录（投信海报、App 品牌图等，对齐 Java file.upload.path）
type FileUploadConfig struct {
	Path string `json:",optional"`
}

// AppReleaseUploadConfig App 安装包上传（对齐 Java app.release.upload.*）
type AppReleaseUploadConfig struct {
	WwwrootBase    string   `json:",optional"`
	SubPath        string   `json:",optional"`
	UrlScheme      string   `json:",optional"`
	DefaultDomain  string   `json:",optional"`
	AllowedDomains []string `json:",optional"`
}
