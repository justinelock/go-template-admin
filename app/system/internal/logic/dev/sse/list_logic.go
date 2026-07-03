package sse

import (
	"context"

	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/toolkit/errx"

	"github.com/zeromicro/go-zero/core/logx"
)

type ListLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewListLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ListLogic {
	return &ListLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

type sseUserRow struct {
	UserID   string `gorm:"column:user_id"`
	UserName string `gorm:"column:username"`
	NickName string `gorm:"column:nick_name"`
	DeptName string `gorm:"column:dept_name"`
}

// List 返回用户列表，供 SSE 演示页选择推送对象（非真实 SSE 连接表）
func (l *ListLogic) List() (resp []types.SseUserInfo, err error) {
	sysUser := l.svcCtx.Dal.Query.SysUser
	sysDept := l.svcCtx.Dal.Query.SysDept

	var rows []sseUserRow
	err = sysUser.WithContext(l.ctx).
		LeftJoin(sysDept, sysDept.DeptID.EqCol(sysUser.DeptID)).
		Where(sysUser.DelFlag.Eq("0")).
		Select(sysUser.UserID, sysUser.UserName, sysUser.NickName, sysDept.DeptName).
		Limit(100).
		Scan(&rows)
	if err != nil {
		return nil, errx.GORMErr(err)
	}

	resp = make([]types.SseUserInfo, 0, len(rows))
	for _, row := range rows {
		resp = append(resp, types.SseUserInfo{
			UserId:   row.UserID,
			UserName: row.UserName,
			NickName: row.NickName,
			DeptName: row.DeptName,
		})
	}
	return resp, nil
}
