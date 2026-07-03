package notice

import (
	"context"
	"ovra/app/system/internal/dal/model"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/utils"

	"github.com/zeromicro/go-zero/core/logx"
)

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

func (l *AddLogic) Add(req *types.ModifyNoticeReq) error {
	// 1. 生成雪花主键 notice_id（表主键，前端列表/编辑/删除均依赖此字段）
	// 2. 组装实体并入库（create_by 等审计字段由 GORM 插件写入）
	notice := &model.SysNotice{
		NoticeID:      utils.GetID(),
		NoticeTitle:   req.NoticeTitle,
		NoticeType:    req.NoticeType,
		NoticeContent: []byte(req.NoticeContent),
		Status:        req.Status,
		Remark:        req.Remark,
	}
	if err := l.svcCtx.Dal.SysNoticeDal.Insert(l.ctx, notice); err != nil {
		return err
	}
	return nil
}
