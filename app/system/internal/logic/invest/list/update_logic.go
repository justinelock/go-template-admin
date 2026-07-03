// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package list

import (
	"context"
	"strings"

	"ovra/app/system/internal/dal"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

// UpdateLogic 修改投信产品（对齐 Java PUT /fubang/fund）
type UpdateLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdateLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateLogic {
	return &UpdateLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UpdateLogic) Update(req *types.InvestListSaveReq) error {
	id, err := dal.ParseFundID(req.Id)
	if err != nil {
		return err
	}
	in, err := saveReqToInput(req)
	if err != nil {
		return err
	}
	in.ID = id
	if err := dal.NormalizeFundSaveInput(&in); err != nil {
		return err
	}
	// 海报：空串清空；有值则落盘或保留已存 URL
	posterRaw := strings.TrimSpace(req.Poster)
	if posterRaw == "" {
		empty := ""
		in.Poster = &empty
	} else {
		poster, err := dal.ResolveFundPoster(l.svcCtx.Config.FileUpload.Path, posterRaw, in.Code, id)
		if err != nil {
			return err
		}
		in.Poster = poster
	}
	// rate 变更后的增量收益补提由定时任务兜底（Go 侧暂未实现 recalculateForFundCode）
	return l.svcCtx.Dal.FbMemberDal.UpdateFund(l.ctx, in)
}
