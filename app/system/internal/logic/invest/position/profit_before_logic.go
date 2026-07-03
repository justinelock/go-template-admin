// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package position

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// ProfitBeforeLogic 查询修改前收益（对齐 Java getProfitBefore）
type ProfitBeforeLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewProfitBeforeLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ProfitBeforeLogic {
	return &ProfitBeforeLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *ProfitBeforeLogic) ProfitBefore(req *types.InvestPositionProfitBeforeReq) (*types.InvestPositionProfitBeforeResp, error) {
	positionID, _ := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	// 参数不全时与 Java 一致返回 null
	if positionID <= 0 || strings.TrimSpace(req.ProfitDate) == "" {
		return &types.InvestPositionProfitBeforeResp{Profit: nil}, nil
	}
	// 查当日 fb_fund_profit_log.profit_amount
	amount, err := l.svcCtx.Dal.FbMemberDal.GetPositionProfitForDay(l.ctx, positionID, req.ProfitDate)
	if err != nil {
		return nil, err
	}
	return &types.InvestPositionProfitBeforeResp{Profit: amount}, nil
}
