// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"context"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// DeleteLogic 删除投信产品（对齐 Java DELETE /fubang/fund）
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

func (l *DeleteLogic) Delete(req *types.IdsReq) error {
	if req == nil || strings.TrimSpace(req.Ids) == "" {
		return errx.BizErr("请选择要删除的投信")
	}
	parts := strings.Split(req.Ids, ",")
	ids := make([]int64, 0, len(parts))
	for _, p := range parts {
		id, err := dal.ParseFundID(strings.TrimSpace(p))
		if err != nil {
			return err
		}
		ids = append(ids, id)
	}
	return l.svcCtx.Dal.FbMemberDal.DeleteFundsByIds(l.ctx, ids)
}
