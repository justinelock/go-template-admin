package brand

import (
	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/types"
	"ovra/toolkit/upload"
)

func mapBrandingToItem(r dal.AppBrandingVO) *types.AppBrandingItem {
	return &types.AppBrandingItem{
		Id:                   dal.IDStr(r.ID),
		Revision:             r.Revision,
		SplashUrl:            r.SplashURL,
		SplashEnabled:        r.SplashEnabled,
		HomeBannerUrl:        r.HomeBannerURL,
		HomeBannerEnabled:    r.HomeBannerEnabled,
		ProfilePosterUrl:     r.ProfilePosterURL,
		ProfilePosterEnabled: r.ProfilePosterEnabled,
		UpdatedAt:            dal.FormatFbTimeVal(r.UpdatedAt),
		UpdatedBy:            r.UpdatedBy,
	}
}

func defaultBrandingItem() *types.AppBrandingItem {
	return &types.AppBrandingItem{
		Revision:             "0",
		SplashEnabled:        true,
		HomeBannerEnabled:    true,
		ProfilePosterEnabled: false,
	}
}

func saveReqToInput(req *types.AppBrandingSaveReq, uploadPath, operator string) (dal.AppBrandingSaveInput, error) {
	splash, err := resolveBrandingURL(uploadPath, req.SplashUrl, "splash")
	if err != nil {
		return dal.AppBrandingSaveInput{}, err
	}
	banner, err := resolveBrandingURL(uploadPath, req.HomeBannerUrl, "home_banner")
	if err != nil {
		return dal.AppBrandingSaveInput{}, err
	}
	poster, err := resolveBrandingURL(uploadPath, req.ProfilePosterUrl, "profile_poster")
	if err != nil {
		return dal.AppBrandingSaveInput{}, err
	}
	splashEnabled := req.SplashEnabled
	homeBannerEnabled := req.HomeBannerEnabled
	profilePosterEnabled := req.ProfilePosterEnabled
	return dal.AppBrandingSaveInput{
		SplashURL:            splash,
		SplashEnabled:        splashEnabled,
		HomeBannerURL:        banner,
		HomeBannerEnabled:    homeBannerEnabled,
		ProfilePosterURL:     poster,
		ProfilePosterEnabled: profilePosterEnabled,
		UpdatedBy:            operator,
	}, nil
}

func resolveBrandingURL(uploadPath, raw, kind string) (string, error) {
	if upload.IsBrandingAlreadyStored(raw) {
		return raw, nil
	}
	return upload.SaveBrandingBase64(uploadPath, raw, kind)
}
