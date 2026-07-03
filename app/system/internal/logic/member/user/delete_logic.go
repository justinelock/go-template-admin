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

// DeleteLogic 业务用户逻辑删除（fb_users.flag=1）
type DeleteLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDeleteLogic(ctx context.Context, svcCtx *svc.ServiceContext) *DeleteLogic {
	return &DeleteLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

// Delete 按路径 ids（逗号分隔）软删用户
func (l *DeleteLogic) Delete(req *types.IdsReq) error {
	if req == nil || strings.TrimSpace(req.Ids) == "" {
		return errx.BizErr("请选择要删除的用户")
	}
	parts := strings.Split(req.Ids, ",")
	ids := make([]string, 0, len(parts))
	for _, p := range parts {
		if id := strings.TrimSpace(p); id != "" {
			ids = append(ids, id)
		}
	}
	if len(ids) == 0 {
		return errx.BizErr("请选择要删除的用户")
	}
	return l.svcCtx.Dal.FbMemberDal.SoftDeleteUsers(l.ctx, ids)
}
