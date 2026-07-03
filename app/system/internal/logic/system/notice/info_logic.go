package notice

import (
	"context"
	"ovra/toolkit/errx"

	"github.com/jinzhu/copier"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type InfoLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewInfoLogic(ctx context.Context, svcCtx *svc.ServiceContext) *InfoLogic {
	return &InfoLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *InfoLogic) Info(req *types.IdReq) (resp *types.NoticeBase, err error) {
	resp = new(types.NoticeBase)
	// 1. 按 notice_id 主键查询
	sysNotice, err := l.svcCtx.Dal.SysNoticeDal.SelectById(l.ctx, req.Id)
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	// 2. 映射为 API 响应（公告内容为 []byte，需转 string）
	if err = copier.Copy(resp, sysNotice); err != nil {
		return nil, err
	}
	resp.NoticeContent = string(sysNotice.NoticeContent)
	return resp, nil
}
