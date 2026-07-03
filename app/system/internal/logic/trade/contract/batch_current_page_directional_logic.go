// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package contract

import (
	"context"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// BatchCurrentPageDirectionalLogic 本页四态批量控单（对齐 Java updateControlBatchByCurrentPageDirectional）
type BatchCurrentPageDirectionalLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewBatchCurrentPageDirectionalLogic(ctx context.Context, svcCtx *svc.ServiceContext) *BatchCurrentPageDirectionalLogic {
	return &BatchCurrentPageDirectionalLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *BatchCurrentPageDirectionalLogic) BatchCurrentPageDirectional(req *types.TradeContractBatchDirectionalReq) (resp *types.TradeContractBatchDirectionalResp, err error) {
	if req == nil || strings.TrimSpace(req.ControlState) == "" {
		return nil, errx.BizErr("控盘状态不能为空")
	}
	code := strings.ToUpper(strings.TrimSpace(req.ControlState))
	if code == "RANDOM" {
		return nil, errx.BizErr("本页批量不支持全自然，请使用配置弹窗")
	}
	count, err := l.svcCtx.Dal.FbMemberDal.BatchControlCurrentPageDirectional(l.ctx, dal.ContractOrderPageQuery{
		Keyword:   req.Keyword,
		Status:    req.Status,
		BeginTime: req.BeginTime,
		EndTime:   req.EndTime,
		PageNum:   req.PageNum,
		PageSize:  req.PageSize,
	}, req.ControlState)
	if err != nil {
		return nil, err
	}
	if count == 0 {
		return nil, errx.BizErr("当前页没有可控制的进行中订单")
	}
	return &types.TradeContractBatchDirectionalResp{AffectedCount: count}, nil
}
