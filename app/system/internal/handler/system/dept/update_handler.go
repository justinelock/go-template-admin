// Code scaffolded by goctl. Safe to edit.
// goctl 1.9.2

package dept

import (
	"encoding/json"
	"io"
	"net/http"
	"strconv"

	"ovra/app/system/internal/logic/system/dept"
	"ovra/app/system/internal/svc"
	"ovra/app/system/internal/types"

	"github.com/zeromicro/go-zero/rest/httpx"
)

func UpdateHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// 兼容前端 parentId 传 number 的场景：
		// 1. 先读取原始 JSON
		// 2. 将 parentId 统一转换为 string
		// 3. 再反序列化到强类型请求结构体
		body, err := io.ReadAll(r.Body)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}
		var raw map[string]any
		if err := json.Unmarshal(body, &raw); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}
		if v, ok := raw["parentId"]; ok {
			switch val := v.(type) {
			case string:
				raw["parentId"] = val
			case float64:
				raw["parentId"] = strconv.FormatFloat(val, 'f', -1, 64)
			case int:
				raw["parentId"] = strconv.Itoa(val)
			}
		}

		var req types.ModifyDeptReq
		bs, _ := json.Marshal(raw)
		if err := json.Unmarshal(bs, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := dept.NewUpdateLogic(r.Context(), svcCtx)
		err = l.Update(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, nil)
		}
	}
}
