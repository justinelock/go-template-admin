package auth

import (
	"context"

	"ovra/app/system/internal/logic/sysrpc"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"
	"ovra/app/system/pb/system"

	"github.com/zeromicro/go-zero/core/logx"
)

// TenantListLogic 登录页租户下拉（进程内 TenantList）
type TenantListLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewTenantListLogic(ctx context.Context, svcCtx *svc.ServiceContext) *TenantListLogic {
	return &TenantListLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *TenantListLogic) TenantList() (resp *types.TenantResp, err error) {
	resp = new(types.TenantResp)
	listResp, err := sysrpclogic.NewTenantListLogic(l.ctx, l.svcCtx).TenantList(&system.EmptyReq{})
	if err != nil {
		return
	}
	resp.TenantEnabled = listResp.TenantEnable
	if resp.TenantEnabled {
		resp.VoList = make([]types.TenantVo, 0)
		for _, v := range listResp.List {
			vo := types.TenantVo{
				TenantId:    v.TenantId,
				CompanyName: v.CompanyName,
				Domain:      v.Domain,
			}
			resp.VoList = append(resp.VoList, vo)
		}
	}
	return
}
