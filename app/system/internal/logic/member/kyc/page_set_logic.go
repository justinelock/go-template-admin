// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package kyc

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// PageSetLogic 实名认证列表分页
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

// PageSet 分页查询 fb_identity_verify 并联用户基础信息
func (l *PageSetLogic) PageSet(req *types.PageSetMemberKycReq) (resp *types.PageSetMemberKycResp, err error) {
	rows, total, err := l.svcCtx.Dal.FbMemberDal.PageKyc(l.ctx, dal.KycPageQuery{
		Keyword:    req.Keyword,
		AuthStatus: req.AuthStatus,
		IdCardNo:   req.IdCardNo,
		Username:   req.Username,
		RealName:   req.RealName,
		BeginTime:  req.BeginTime,
		EndTime:    req.EndTime,
		PageNum:    req.PageNum,
		PageSize:   req.PageSize,
	})
	if err != nil {
		return nil, err
	}
	items := make([]*types.MemberKycItem, 0, len(rows))
	for _, r := range rows {
		items = append(items, &types.MemberKycItem{
			Id:           dal.IDStr(r.ID),
			UserId:       dal.IDStr(r.UserID),
			Username:     r.Username,
			Mobile:       r.Mobile,
			RealName:     r.RealName,
			IdCardNo:     r.IDCardNo,
			IdCardFront:  r.IDCardFront,
			IdCardBack:   r.IDCardBack,
			Status:       r.Status,
			RejectReason: r.RejectReason,
			VerifiedAt:   dal.FormatFbTime(r.VerifiedAt),
			CreatedAt:    dal.FormatFbTimeVal(r.CreatedAt),
			UpdatedAt:    dal.FormatFbTime(r.UpdatedAt),
		})
	}
	return &types.PageSetMemberKycResp{Rows: items, Total: total}, nil
}
