package dal

// App 品牌与版本 DAL：app_branding_config、app_release_versions

import (
	"context"
	"strings"
	"time"

	"ovra/toolkit/errx"
	"ovra/toolkit/upload"
)

// AppBrandingVO 品牌配置
type AppBrandingVO struct {
	ID                   int64
	Revision             string
	SplashURL            string
	SplashEnabled        bool
	HomeBannerURL        string
	HomeBannerEnabled    bool
	ProfilePosterURL     string
	ProfilePosterEnabled bool
	UpdatedAt            time.Time
	UpdatedBy            string
}

// AppBrandingSaveInput 品牌配置保存
type AppBrandingSaveInput struct {
	ID                   int64
	SplashURL            string
	SplashEnabled        bool
	HomeBannerURL        string
	HomeBannerEnabled    bool
	ProfilePosterURL     string
	ProfilePosterEnabled bool
	UpdatedBy            string
}

// AppReleaseVersionVO 发布版本
type AppReleaseVersionVO struct {
	ID          int64
	Version     string
	Description string
	DownloadURL string
	ApkFileURL  string
	IosURL      string
	IpaFileURL  string
	IsForce     bool
	IsHotUpdate bool
	UpdatedAt   time.Time
}

// AppReleaseVersionSaveInput 版本保存
type AppReleaseVersionSaveInput struct {
	ID          int64
	Version     string
	Description string
	DownloadURL string
	ApkFileURL  string
	IosURL      string
	IpaFileURL  string
	IsForce     bool
	IsHotUpdate bool
}

type appBrandingRow struct {
	ID                   int64
	Revision             string
	SplashURL            string
	SplashEnabled        int
	HomeBannerURL        string
	HomeBannerEnabled    int
	ProfilePosterURL     string
	ProfilePosterEnabled int
	UpdatedAt            time.Time
	UpdatedBy            string
}

type appReleaseVersionRow struct {
	ID          int64
	Version     string
	Description string
	DownloadURL string
	ApkFileURL  string
	IosURL      string
	IpaFileURL  string
	IsForce     int
	IsHotUpdate int
	UpdatedAt   time.Time
	CreatedAt   time.Time
}

// GetActiveBranding 取最新一条品牌配置
func (d *AppDal) GetActiveBranding(ctx context.Context) (*AppBrandingVO, error) {
	var raw appBrandingRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT id, COALESCE(revision,'0') AS revision,
			COALESCE(splash_url,'') AS splash_url, COALESCE(splash_enabled,0) AS splash_enabled,
			COALESCE(home_banner_url,'') AS home_banner_url, COALESCE(home_banner_enabled,0) AS home_banner_enabled,
			COALESCE(profile_poster_url,'') AS profile_poster_url, COALESCE(profile_poster_enabled,0) AS profile_poster_enabled,
			updated_at, COALESCE(updated_by,'') AS updated_by
		FROM app_branding_config ORDER BY updated_at DESC LIMIT 1`).Scan(&raw).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if raw.ID == 0 {
		return nil, nil
	}
	return mapBrandingRow(raw), nil
}

// SaveBranding 保存品牌配置并 bump revision
func (d *AppDal) SaveBranding(ctx context.Context, in AppBrandingSaveInput) error {
	if err := normalizeBrandingSaveInput(&in); err != nil {
		return err
	}
	revision := time.Now().Format("20060102150405")
	now := time.Now()

	var existing appBrandingRow
	_ = d.db.WithContext(ctx).Raw(`SELECT id FROM app_branding_config ORDER BY updated_at DESC LIMIT 1`).Scan(&existing).Error

	splashURL := nullableStr(in.SplashEnabled, in.SplashURL)
	bannerURL := nullableStr(in.HomeBannerEnabled, in.HomeBannerURL)
	posterURL := nullableStr(in.ProfilePosterEnabled, in.ProfilePosterURL)

	if existing.ID > 0 {
		res := d.db.WithContext(ctx).Exec(`
			UPDATE app_branding_config SET
				revision=?, splash_url=?, splash_enabled=?, home_banner_url=?, home_banner_enabled=?,
				profile_poster_url=?, profile_poster_enabled=?, updated_at=?, updated_by=?
			WHERE id=?`,
			revision, splashURL, boolToTiny(in.SplashEnabled), bannerURL, boolToTiny(in.HomeBannerEnabled),
			posterURL, boolToTiny(in.ProfilePosterEnabled), now, in.UpdatedBy, existing.ID)
		if res.Error != nil {
			return errx.GORMErr(res.Error)
		}
		return nil
	}

	res := d.db.WithContext(ctx).Exec(`
		INSERT INTO app_branding_config (
			revision, splash_url, splash_enabled, home_banner_url, home_banner_enabled,
			profile_poster_url, profile_poster_enabled, updated_at, updated_by
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		revision, splashURL, boolToTiny(in.SplashEnabled), bannerURL, boolToTiny(in.HomeBannerEnabled),
		posterURL, boolToTiny(in.ProfilePosterEnabled), now, in.UpdatedBy)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	return nil
}

// GetActiveReleaseVersion 取 created_at 最新版本（对齐 Java）
func (d *AppDal) GetActiveReleaseVersion(ctx context.Context) (*AppReleaseVersionVO, error) {
	var raw appReleaseVersionRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT id, version, COALESCE(description,'') AS description,
			COALESCE(download_url,'') AS download_url,
			COALESCE(apk_file_url,'') AS apk_file_url,
			COALESCE(ios_url,'') AS ios_url,
			COALESCE(ipa_file_url,'') AS ipa_file_url,
			COALESCE(is_force,0) AS is_force, COALESCE(is_hot_update,0) AS is_hot_update,
			updated_at, created_at
		FROM app_release_versions ORDER BY created_at DESC LIMIT 1`).Scan(&raw).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if raw.ID == 0 {
		return nil, nil
	}
	return mapReleaseVersionRow(raw), nil
}

// UpdateReleaseVersion 更新发布版本
func (d *AppDal) UpdateReleaseVersion(ctx context.Context, in AppReleaseVersionSaveInput) error {
	if err := normalizeReleaseVersionSaveInput(&in); err != nil {
		return err
	}
	if in.ID <= 0 {
		in.ID = 1
	}
	now := time.Now()
	res := d.db.WithContext(ctx).Exec(`
		UPDATE app_release_versions SET
			version=?, description=?, download_url=?, apk_file_url=?, ios_url=?, ipa_file_url=?,
			is_force=?, is_hot_update=?, updated_at=?
		WHERE id=?`,
		in.Version, in.Description, in.DownloadURL, nullIfEmpty(in.ApkFileURL), nullIfEmpty(in.IosURL), nullIfEmpty(in.IpaFileURL),
		boolToTiny(in.IsForce), boolToTiny(in.IsHotUpdate), now, in.ID)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("版本记录不存在")
	}
	return nil
}

// ApplyUploadedPackage 上传安装包后回写版本表
func (d *AppDal) ApplyUploadedPackage(ctx context.Context, url, kind, fileName string) error {
	url = strings.TrimSpace(url)
	kind = strings.ToLower(strings.TrimSpace(kind))
	if url == "" || kind == "" {
		return nil
	}
	row, err := d.GetActiveReleaseVersion(ctx)
	if err != nil {
		return err
	}
	if row == nil {
		return errx.BizErr("版本记录不存在，请先初始化 app_release_versions")
	}
	in := AppReleaseVersionSaveInput{
		ID:          row.ID,
		Version:     row.Version,
		Description: row.Description,
		DownloadURL: row.DownloadURL,
		ApkFileURL:  row.ApkFileURL,
		IosURL:      row.IosURL,
		IpaFileURL:  row.IpaFileURL,
		IsForce:     row.IsForce,
		IsHotUpdate: row.IsHotUpdate,
	}
	if kind == "apk" {
		in.ApkFileURL = url
		in.DownloadURL = url
	} else if kind == "ipa" {
		in.IpaFileURL = url
	} else {
		return nil
	}
	if v := upload.ParseVersionFromPackageFileName(fileName); v != "" {
		in.Version = v
	}
	return d.UpdateReleaseVersion(ctx, in)
}

func normalizeBrandingSaveInput(in *AppBrandingSaveInput) error {
	if in.SplashEnabled && strings.TrimSpace(in.SplashURL) == "" {
		return errx.BizErr("启用远程启动页时必须上传启动页图片或填写外部链接")
	}
	if in.HomeBannerEnabled && strings.TrimSpace(in.HomeBannerURL) == "" {
		return errx.BizErr("启用远程首页横幅时必须上传横幅图片或填写外部链接")
	}
	if in.ProfilePosterEnabled && strings.TrimSpace(in.ProfilePosterURL) == "" {
		return errx.BizErr("启用远程「我的」顶部海报时必须上传图片或填写外部链接")
	}
	return nil
}

func normalizeReleaseVersionSaveInput(in *AppReleaseVersionSaveInput) error {
	in.Version = strings.TrimSpace(in.Version)
	in.Description = strings.TrimSpace(in.Description)
	in.DownloadURL = strings.TrimSpace(in.DownloadURL)
	if in.Version == "" || in.Description == "" || in.DownloadURL == "" {
		return errx.BizErr("版本号、描述、下载地址均不能为空")
	}
	return nil
}

func mapBrandingRow(r appBrandingRow) *AppBrandingVO {
	return &AppBrandingVO{
		ID:                   r.ID,
		Revision:             r.Revision,
		SplashURL:            r.SplashURL,
		SplashEnabled:        r.SplashEnabled == 1,
		HomeBannerURL:        r.HomeBannerURL,
		HomeBannerEnabled:    r.HomeBannerEnabled == 1,
		ProfilePosterURL:     r.ProfilePosterURL,
		ProfilePosterEnabled: r.ProfilePosterEnabled == 1,
		UpdatedAt:            r.UpdatedAt,
		UpdatedBy:            r.UpdatedBy,
	}
}

func mapReleaseVersionRow(r appReleaseVersionRow) *AppReleaseVersionVO {
	return &AppReleaseVersionVO{
		ID:          r.ID,
		Version:     r.Version,
		Description: r.Description,
		DownloadURL: r.DownloadURL,
		ApkFileURL:  r.ApkFileURL,
		IosURL:      r.IosURL,
		IpaFileURL:  r.IpaFileURL,
		IsForce:     r.IsForce == 1,
		IsHotUpdate: r.IsHotUpdate == 1,
		UpdatedAt:   r.UpdatedAt,
	}
}

func nullableStr(enabled bool, url string) any {
	if !enabled {
		return nil
	}
	u := strings.TrimSpace(url)
	if u == "" {
		return nil
	}
	return u
}

func boolToTiny(v bool) int {
	if v {
		return 1
	}
	return 0
}
