// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// WinLogic 合约订单控单-赢（对齐 Java updateControl WIN）
type WinLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewWinLogic(ctx context.Context, svcCtx *svc.ServiceContext) *WinLogic {
	return &WinLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *WinLogic) Win(req *types.IdReq) error {
	id, err := parseContractOrderID(req.Id)
	if err != nil {
		return err
	}
	return l.svcCtx.Dal.FbMemberDal.UpdateContractControl(l.ctx, id, 1)
}

func parseContractOrderID(idStr string) (int64, error) {
	id, err := strconv.ParseInt(strings.TrimSpace(idStr), 10, 64)
	if err != nil || id <= 0 {
		return 0, errx.BizErr("订单不存在")
	}
	return id, nil
}
