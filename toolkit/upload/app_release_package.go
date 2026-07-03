// App 安装包上传落盘（对齐 Java AppReleaseUploadServiceImpl）

package upload

import (
	"io"
	"mime/multipart"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"ovra/toolkit/errx"
)

var safePackageName = regexp.MustCompile(`^[a-zA-Z0-9._-]+$`)
var fubangPackageVersion = regexp.MustCompile(`(?i)fubang-v([\d.]+)\.(apk|ipa)$`)
var genericPackageVersion = regexp.MustCompile(`(?i)v?(\d+\.\d+\.\d+(?:\.\d+)?)\.(apk|ipa)$`)

const maxPackageSize = 300 * 1024 * 1024

// AppReleaseUploadSettings 安装包上传配置（由 system.Config.AppReleaseUpload 传入）
type AppReleaseUploadSettings struct {
	WwwrootBase    string
	SubPath        string
	UrlScheme      string
	DefaultDomain  string
	AllowedDomains []string
}

// AppPackageUploadResult 安装包上传结果
type AppPackageUploadResult struct {
	URL      string
	Path     string
	Domain   string
	FileName string
	Kind     string
}

// SaveAppReleasePackage 落盘到 wwwroot/{domain}/{subPath}/{fileName}
func SaveAppReleasePackage(cfg AppReleaseUploadSettings, file multipart.File, header *multipart.FileHeader, domain, fileNameOverride string) (*AppPackageUploadResult, error) {
	if file == nil || header == nil {
		return nil, errx.BizErr("请选择 APK 或 IPA 文件")
	}
	if header.Size > maxPackageSize {
		return nil, errx.BizErr("安装包不能超过 300MB")
	}
	resolvedDomain, err := resolveUploadDomain(cfg, domain)
	if err != nil {
		return nil, err
	}
	resolvedFileName, err := resolvePackageFileName(header.Filename, fileNameOverride)
	if err != nil {
		return nil, err
	}
	kind := packageExtension(resolvedFileName)
	if kind != "apk" && kind != "ipa" {
		return nil, errx.BizErr("仅支持 .apk 或 .ipa 文件")
	}

	targetDir, err := resolvePackageTargetDir(cfg, resolvedDomain)
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(targetDir, 0o755); err != nil {
		return nil, errx.BizErr("创建上传目录失败: " + err.Error())
	}
	targetFile := filepath.Join(targetDir, resolvedFileName)
	if !strings.HasPrefix(filepath.Clean(targetFile), filepath.Clean(targetDir)) {
		return nil, errx.BizErr("非法文件名")
	}
	out, err := os.Create(targetFile)
	if err != nil {
		return nil, errx.BizErr("文件保存失败: " + err.Error())
	}
	defer out.Close()
	if _, err := io.Copy(out, file); err != nil {
		return nil, errx.BizErr("文件保存失败: " + err.Error())
	}

	publicURL := buildPackagePublicURL(cfg, resolvedDomain, resolvedFileName)
	return &AppPackageUploadResult{
		URL:      publicURL,
		Path:     targetFile,
		Domain:   resolvedDomain,
		FileName: resolvedFileName,
		Kind:     kind,
	}, nil
}

// BuildUploadOptions 管理端上传选项
func BuildUploadOptions(cfg AppReleaseUploadSettings) (defaultDomain string, allowed []string, urlPattern, wwwroot string) {
	defaultDomain = strings.TrimSpace(cfg.DefaultDomain)
	if defaultDomain == "" {
		defaultDomain = "app.fubonplus.com"
	}
	allowed = cfg.AllowedDomains
	if len(allowed) == 0 {
		allowed = []string{defaultDomain}
	}
	scheme := strings.TrimSpace(cfg.UrlScheme)
	if scheme == "" {
		scheme = "https"
	}
	sub := normalizeUploadSubPath(cfg.SubPath)
	urlPattern = scheme + "://{domain}/" + sub + "/{fileName}"
	base := strings.TrimSpace(cfg.WwwrootBase)
	if base == "" {
		base = "/www/wwwroot"
	}
	abs, err := filepath.Abs(base)
	if err != nil {
		wwwroot = base
	} else {
		wwwroot = abs
	}
	return defaultDomain, allowed, urlPattern, wwwroot
}

// ParseVersionFromPackageFileName 从安装包文件名解析版本号
func ParseVersionFromPackageFileName(fileName string) string {
	name := strings.TrimSpace(fileName)
	if m := fubangPackageVersion.FindStringSubmatch(name); len(m) > 1 {
		return m[1]
	}
	if m := genericPackageVersion.FindStringSubmatch(name); len(m) > 1 {
		return m[1]
	}
	return ""
}

func resolveUploadDomain(cfg AppReleaseUploadSettings, domain string) (string, error) {
	value := strings.TrimSpace(domain)
	if value == "" {
		value = strings.TrimSpace(cfg.DefaultDomain)
	}
	value = strings.ToLower(value)
	if value == "" {
		return "", errx.BizErr("未配置 app.release.upload 默认域名")
	}
	allowed := cfg.AllowedDomains
	if len(allowed) == 0 {
		return "", errx.BizErr("未配置 app.release.upload.allowed-domains")
	}
	for _, d := range allowed {
		if strings.EqualFold(strings.TrimSpace(d), value) {
			return value, nil
		}
	}
	return "", errx.BizErr("域名不在允许列表中: " + value)
}

func resolvePackageFileName(original, override string) (string, error) {
	candidate := strings.TrimSpace(override)
	if candidate == "" {
		candidate = strings.TrimSpace(original)
	}
	if candidate == "" {
		return "", errx.BizErr("文件名不能为空")
	}
	if slash := strings.LastIndexAny(candidate, `/\`); slash >= 0 && slash < len(candidate)-1 {
		candidate = candidate[slash+1:]
	}
	if !safePackageName.MatchString(candidate) {
		return "", errx.BizErr("文件名仅允许字母、数字、点、下划线与连字符")
	}
	ext := packageExtension(candidate)
	if ext != "apk" && ext != "ipa" {
		return "", errx.BizErr("仅支持 .apk 或 .ipa 文件")
	}
	return candidate, nil
}

func packageExtension(fileName string) string {
	dot := strings.LastIndex(fileName, ".")
	if dot < 0 || dot == len(fileName)-1 {
		return ""
	}
	return strings.ToLower(fileName[dot+1:])
}

func resolvePackageTargetDir(cfg AppReleaseUploadSettings, domain string) (string, error) {
	base := strings.TrimSpace(cfg.WwwrootBase)
	if base == "" {
		base = "/www/wwwroot"
	}
	absBase, err := filepath.Abs(base)
	if err != nil {
		return "", err
	}
	sub := normalizeUploadSubPath(cfg.SubPath)
	return filepath.Join(absBase, domain, sub), nil
}

func buildPackagePublicURL(cfg AppReleaseUploadSettings, domain, fileName string) string {
	scheme := strings.TrimSpace(cfg.UrlScheme)
	if scheme == "" {
		scheme = "https"
	}
	sub := normalizeUploadSubPath(cfg.SubPath)
	return scheme + "://" + domain + "/" + sub + "/" + fileName
}

func normalizeUploadSubPath(subPath string) string {
	normalized := strings.TrimSpace(subPath)
	if normalized == "" {
		return "download"
	}
	normalized = strings.Trim(normalized, "/")
	if normalized == "" {
		return "download"
	}
	return normalized
}
