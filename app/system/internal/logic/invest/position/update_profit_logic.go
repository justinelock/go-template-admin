// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package position

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// UpdateProfitLogic 修改持仓某日收益（对齐 Java updateProfit）
type UpdateProfitLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdateProfitLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateProfitLogic {
	return &UpdateProfitLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UpdateProfitLogic) UpdateProfit(req *types.InvestPositionUpdateProfitReq) error {
	positionID, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	if err != nil || positionID <= 0 {
		return errx.BizErr("持仓ID不能为空")
	}
	if strings.TrimSpace(req.ProfitDate) == "" {
		return errx.BizErr("收益日期不能为空")
	}
	if req.Profit <= 0 {
		return errx.BizErr("修改后的收益金额必须大于 0")
	}
	// 管理端须先查到修改前收益，避免对空日误提交
	before, err := l.svcCtx.Dal.FbMemberDal.GetPositionProfitForDay(l.ctx, positionID, req.ProfitDate)
	if err != nil {
		return err
	}
	if before == nil {
		return errx.BizErr("该日期暂无收益记录，无法修改")
	}
	// 覆盖 fb_fund_profit_log.profit_amount
	return l.svcCtx.Dal.FbMemberDal.UpdatePositionProfit(l.ctx, positionID, req.ProfitDate, req.Profit)
}
