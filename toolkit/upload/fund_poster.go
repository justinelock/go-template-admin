// 投信海报 base64 落盘（对齐 Java UploadUtil.saveDepositBase64 + FbFundController.resolvePoster）

package upload

import (
	"encoding/base64"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"ovra/toolkit/errx"
	"ovra/toolkit/utils"
)

const fundCategory = "fund"

// IsPosterAlreadyStored 已是公网 URL 或历史相对路径时不再写入磁盘
func IsPosterAlreadyStored(raw string) bool {
	raw = strings.TrimSpace(raw)
	if strings.HasPrefix(raw, "http://") || strings.HasPrefix(raw, "https://") {
		return true
	}
	if strings.Contains(strings.ToLower(raw), "data:image") {
		return false
	}
	if !strings.HasPrefix(raw, "/") {
		return false
	}
	return strings.HasPrefix(raw, "/uploads/") || strings.HasPrefix(raw, "/fund/")
}

// SaveFundPosterBase64 将 base64/data URL 写入 uploadPath/fund/，返回入库路径 /uploads/fund/...
func SaveFundPosterBase64(uploadPath, raw, fileStem string) (string, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "", errx.BizErr("海报数据不能为空")
	}
	if strings.TrimSpace(uploadPath) == "" {
		return "", errx.BizErr("未配置 file.upload.path，无法将海报保存到磁盘")
	}

	payload := raw
	if idx := strings.Index(payload, ","); idx >= 0 {
		payload = payload[idx+1:]
	}
	imageData, err := base64.StdEncoding.DecodeString(payload)
	if err != nil {
		return "", errx.BizErr("海报 Base64 格式不正确")
	}

	stem := strings.TrimSpace(fileStem)
	if stem == "" {
		stem = fundCategory
	}
	stem = strings.ToLower(strings.ReplaceAll(stem, ".", "_"))

	suffix := detectImageSuffix(imageData, raw)
	uuid := utils.GetID()
	fileName := fmt.Sprintf("%s_%s.%s", uuid, stem, suffix)

	dir := filepath.Join(uploadPath, fundCategory)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", errx.BizErr("创建上传目录失败: " + err.Error())
	}
	fullPath := filepath.Join(dir, fileName)
	if err := os.WriteFile(fullPath, imageData, 0o644); err != nil {
		return "", errx.BizErr("投信海报上传失败: " + err.Error())
	}
	// 入库 /uploads/fund/...，与 Nginx alias 约定一致
	return "/uploads/" + fundCategory + "/" + fileName, nil
}

func detectImageSuffix(data []byte, raw string) string {
	if len(data) >= 3 && data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF {
		return "jpeg"
	}
	if len(data) >= 8 && data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47 {
		return "png"
	}
	lower := strings.ToLower(raw)
	switch {
	case strings.Contains(lower, "image/png"):
		return "png"
	case strings.Contains(lower, "image/jpeg"), strings.Contains(lower, "image/jpg"):
		return "jpeg"
	default:
		return "jpeg"
	}
}
