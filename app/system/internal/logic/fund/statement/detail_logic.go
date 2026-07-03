// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package statement

import (
	"context"
	"strconv"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

// DetailLogic 账户流水详情（按主键 id 查询）
type DetailLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDetailLogic(ctx context.Context, svcCtx *svc.ServiceContext) *DetailLogic {
	return &DetailLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *DetailLogic) Detail(req *types.IdReq) (resp *types.FundStatementItem, err error) {
	id, err := strconv.ParseInt(strings.TrimSpace(req.Id), 10, 64)
	if err != nil || id <= 0 {
		return nil, errx.BizErr("流水记录不存在")
	}
	row, err := l.svcCtx.Dal.FbMemberDal.GetAccountFlowByID(l.ctx, id)
	if err != nil {
		return nil, err
	}
	return &types.FundStatementItem{
		Id:           dal.IDStr(row.ID),
		UserId:       dal.IDStr(row.UserID),
		Username:     row.Username,
		Mobile:       row.Mobile,
		RealName:     row.RealName,
		AccountType:  row.AccountType,
		FlowType:     row.FlowType,
		BeforeAmount: row.BeforeAmount,
		FlowAmount:   row.FlowAmount,
		AfterAmount:  row.AfterAmount,
		BusinessNo:   row.BusinessNo,
		Remark:       row.Remark,
		CreatedAt:    dal.FormatFbTimeVal(row.CreatedAt),
		WalletId:     dal.IDStr(row.WalletID),
		Currency:     row.Currency,
		Description:  row.Description,
		Status:       row.Status,
		UpdatedAt:    dal.FormatFbTime(row.UpdatedAt),
	}, nil
}
