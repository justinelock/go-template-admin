// Code scaffolded by goctl. Safe to edit.
// goctl 1.10.0

package team

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

// ChangeParentLogic 更换上级代理（对齐 Java FbUsersServiceImpl.changeAgent）
type ChangeParentLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewChangeParentLogic(ctx context.Context, svcCtx *svc.ServiceContext) *ChangeParentLogic {
	return &ChangeParentLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *ChangeParentLogic) ChangeParent(req *types.MemberTeamChangeParentReq) (resp *types.MemberTeamChangeParentResp, err error) {
	if strings.TrimSpace(req.UserId) == "" {
		return nil, errx.BizErr("用户ID不能为空")
	}
	if strings.TrimSpace(req.Username) == "" {
		return nil, errx.BizErr("上级代理用户名不能为空")
	}
	userID, err := strconv.ParseInt(strings.TrimSpace(req.UserId), 10, 64)
	if err != nil || userID <= 0 {
		return nil, errx.BizErr("用户不存在")
	}
	parentID, parentUsername, err := l.svcCtx.Dal.FbMemberDal.ChangeTeamParentByUsername(
		l.ctx, userID, req.Username,
	)
	if err != nil {
		return nil, err
	}
	resp = &types.MemberTeamChangeParentResp{UserId: dal.IDStr(userID)}
	if parentID > 0 {
		resp.ParentId = dal.IDStr(parentID)
		resp.ParentUsername = parentUsername
	}
	return resp, nil
}
