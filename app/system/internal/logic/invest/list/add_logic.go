// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"context"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/utils"

	"github.com/zeromicro/go-zero/core/logx"
)

// AddLogic 新增投信产品（对齐 Java POST /fubang/fund）
type AddLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAddLogic(ctx context.Context, svcCtx *svc.ServiceContext) *AddLogic {
	return &AddLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *AddLogic) Add(req *types.InvestListSaveReq) error {
	in, err := saveReqToInput(req)
	if err != nil {
		return err
	}
	if err := dal.NormalizeFundSaveInput(&in); err != nil {
		return err
	}
	// 海报 base64 落盘或保留 URL
	poster, err := dal.ResolveFundPoster(l.svcCtx.Config.FileUpload.Path, req.Poster, in.Code, 0)
	if err != nil {
		return err
	}
	in.Poster = poster
	in.ID = utils.GetIDInt64()
	return l.svcCtx.Dal.FbMemberDal.InsertFund(l.ctx, in)
}
