// App 品牌图 multipart/base64 落盘（对齐 Java AppBrandingConfigServiceImpl + FileDirectoryEnum.BRANDING）

package upload

import (
	"encoding/base64"
	"fmt"
	"io"
	"mime/multipart"
	"os"
	"path/filepath"
	"strings"

	"ovra/toolkit/errx"
	"ovra/toolkit/utils"
)

const brandingCategory = "branding"

var allowedBrandingKinds = map[string]struct{}{
	"splash":          {},
	"home_banner":     {},
	"profile_poster":  {},
}

var allowedBrandingMIME = map[string]string{
	"image/jpeg": "jpeg",
	"image/jpg":  "jpeg",
	"image/png":  "png",
	"image/webp": "webp",
}

const maxBrandingImageSize = 5 * 1024 * 1024

// IsBrandingAlreadyStored http(s) 或 /uploads/ 路径不再落盘
func IsBrandingAlreadyStored(raw string) bool {
	raw = strings.TrimSpace(raw)
	if strings.HasPrefix(raw, "http://") || strings.HasPrefix(raw, "https://") {
		return true
	}
	if strings.Contains(strings.ToLower(raw), "data:image") {
		return false
	}
	return strings.HasPrefix(raw, "/uploads/")
}

// NormalizeBrandingKind 校验 kind：splash / home_banner / profile_poster
func NormalizeBrandingKind(kind string) (string, error) {
	k := strings.TrimSpace(strings.ToLower(kind))
	if k == "" {
		return "", errx.BizErr("kind 不能为空，可选 splash、home_banner 或 profile_poster")
	}
	if _, ok := allowedBrandingKinds[k]; !ok {
		return "", errx.BizErr("kind 无效，可选 splash、home_banner 或 profile_poster")
	}
	return k, nil
}

// SaveBrandingMultipart 将 multipart 图片写入 uploadPath/branding/
func SaveBrandingMultipart(uploadPath string, file multipart.File, header *multipart.FileHeader, kind string) (string, error) {
	if file == nil || header == nil {
		return "", errx.BizErr("请选择图片")
	}
	if header.Size > maxBrandingImageSize {
		return "", errx.BizErr("图片不能超过 5MB")
	}
	contentType := strings.ToLower(strings.TrimSpace(header.Header.Get("Content-Type")))
	suffix, ok := allowedBrandingMIME[contentType]
	if !ok {
		return "", errx.BizErr("仅支持 jpg/png/webp 图片")
	}
	stem, err := NormalizeBrandingKind(kind)
	if err != nil {
		return "", err
	}
	data, err := io.ReadAll(file)
	if err != nil {
		return "", errx.BizErr("读取图片失败: " + err.Error())
	}
	return writeBrandingFile(uploadPath, stem, suffix, data)
}

// SaveBrandingBase64 将 base64/data URL 写入 branding 目录
func SaveBrandingBase64(uploadPath, raw, kind string) (string, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "", nil
	}
	if IsBrandingAlreadyStored(raw) {
		return raw, nil
	}
	stem, err := NormalizeBrandingKind(kind)
	if err != nil {
		return "", err
	}
	payload := raw
	if idx := strings.Index(payload, ","); idx >= 0 {
		payload = payload[idx+1:]
	}
	imageData, err := decodeBase64(payload)
	if err != nil {
		return "", errx.BizErr("图片 Base64 格式不正确")
	}
	suffix := detectImageSuffix(imageData, raw)
	return writeBrandingFile(uploadPath, stem, suffix, imageData)
}

func writeBrandingFile(uploadPath, stem, suffix string, data []byte) (string, error) {
	if strings.TrimSpace(uploadPath) == "" {
		return "", errx.BizErr("未配置 file.upload.path，无法保存图片到磁盘")
	}
	stem = strings.ToLower(strings.ReplaceAll(stem, ".", "_"))
	fileName := fmt.Sprintf("%s_%s.%s", utils.GetID(), stem, suffix)
	dir := filepath.Join(uploadPath, brandingCategory)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", errx.BizErr("创建上传目录失败: " + err.Error())
	}
	fullPath := filepath.Join(dir, fileName)
	if err := os.WriteFile(fullPath, data, 0o644); err != nil {
		return "", errx.BizErr("图片上传失败: " + err.Error())
	}
	return "/uploads/" + brandingCategory + "/" + fileName, nil
}

func decodeBase64(payload string) ([]byte, error) {
	return base64.StdEncoding.DecodeString(payload)
}
