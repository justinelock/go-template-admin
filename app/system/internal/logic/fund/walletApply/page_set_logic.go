// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package walletApply

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 钱包申请分页（对齐 Java FbAccountApplicationServiceImpl.getPageData）
type PageSetLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewPageSetLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PageSetLogic {
	return &PageSetLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *PageSetLogic) PageSet(req *types.PageSetFundWalletApplyReq) (resp *types.PageSetFundWalletApplyResp, err error) {
	f := dal.WalletApplyListFilter{
		Keyword:     req.Keyword,
		Status:      req.Status,
		State:       req.State,
		Verified:    req.Verified,
		UserId:      req.UserId,
		Username:    req.Username,
		Mobile:      req.Mobile,
		RealName:    req.RealName,
		AccountType: req.AccountType,
		BeginTime:   req.BeginTime,
		EndTime:     req.EndTime,
		PageNum:     req.PageNum,
		PageSize:    req.PageSize,
	}
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageWalletApplications(l.ctx, f)
	if err != nil {
		return nil, err
	}
	items := make([]*types.FundWalletApplyItem, 0, len(rows))
	for _, r := range rows {
		item := &types.FundWalletApplyItem{
			Id:                  dal.IDStr(r.ID),
			UserId:              dal.IDStr(r.UserID),
			Username:            r.Username,
			Mobile:              r.Mobile,
			RealName:            r.RealName,
			AccountType:         r.AccountType,
			Status:              r.Status,
			State:               r.State,
			RiskAssessmentScore: int64(r.RiskAssessmentScore),
			RejectReason:        r.RejectReason,
			ApplyTime:           dal.FormatFbTimeVal(r.ApplyTime),
			Remark:              r.Remark,
			CreatedAt:           dal.FormatFbTimeVal(r.CreatedAt),
			UpdatedAt:           dal.FormatFbTimeVal(r.UpdatedAt),
			AuditUser:           r.AuditUser,
		}
		if r.AuditUserID > 0 {
			item.AuditUserId = dal.IDStr(r.AuditUserID)
		}
		if r.AuditTime != nil {
			item.AuditTime = dal.FormatFbTimeVal(*r.AuditTime)
		}
		items = append(items, item)
	}
	return &types.PageSetFundWalletApplyResp{Rows: items, Total: total}, nil
}
