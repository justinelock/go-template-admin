package version

import (
	"strconv"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/types"
)

func mapVersionToItem(r dal.AppReleaseVersionVO) *types.AppReleaseVersionItem {
	return &types.AppReleaseVersionItem{
		Id:          dal.IDStr(r.ID),
		Version:     r.Version,
		Description: r.Description,
		DownloadUrl: r.DownloadURL,
		ApkFileUrl:  r.ApkFileURL,
		IosUrl:      r.IosURL,
		IpaFileUrl:  r.IpaFileURL,
		IsForce:     r.IsForce,
		IsHotUpdate: r.IsHotUpdate,
		UpdatedAt:   dal.FormatFbTimeVal(r.UpdatedAt),
	}
}

func defaultVersionItem() *types.AppReleaseVersionItem {
	return &types.AppReleaseVersionItem{
		Id:          "1",
		IsForce:     false,
		IsHotUpdate: false,
	}
}

func saveReqToInput(req *types.AppReleaseVersionSaveReq) dal.AppReleaseVersionSaveInput {
	in := dal.AppReleaseVersionSaveInput{
		Version:     strings.TrimSpace(req.Version),
		Description: strings.TrimSpace(req.Description),
		DownloadURL: strings.TrimSpace(req.DownloadUrl),
		ApkFileURL:  strings.TrimSpace(req.ApkFileUrl),
		IosURL:      strings.TrimSpace(req.IosUrl),
		IpaFileURL:  strings.TrimSpace(req.IpaFileUrl),
		IsForce:     req.IsForce,
		IsHotUpdate: req.IsHotUpdate,
	}
	if req.Id != "" {
		if id, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64); err == nil && id > 0 {
			in.ID = id
		}
	}
	return in
}
