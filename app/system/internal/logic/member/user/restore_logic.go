// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package user

import (
	"context"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// RestoreLogic 恢复已逻辑删除的业务用户（fb_users.flag=0）
type RestoreLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewRestoreLogic(ctx context.Context, svcCtx *svc.ServiceContext) *RestoreLogic {
	return &RestoreLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *RestoreLogic) Restore(req *types.IdsReq) error {
	if req == nil || strings.TrimSpace(req.Ids) == "" {
		return errx.BizErr("请选择要恢复的用户")
	}
	parts := strings.Split(req.Ids, ",")
	ids := make([]string, 0, len(parts))
	for _, p := range parts {
		if id := strings.TrimSpace(p); id != "" {
			ids = append(ids, id)
		}
	}
	if len(ids) == 0 {
		return errx.BizErr("请选择要恢复的用户")
	}
	return l.svcCtx.Dal.FbMemberDal.RestoreUsers(l.ctx, ids)
}
