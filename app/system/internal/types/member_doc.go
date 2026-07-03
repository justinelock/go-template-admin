// 业务用户管理（member）请求/响应类型说明
//
// MemberUser*、MemberKyc*、MemberWallet*、MemberReport*、MemberTeam*、MemberLoginLog*
// 等结构体由 goctl 根据 desc/system/api/member/*.api 生成，落在本包 types.go 中。
//
// 维护约定（见 .cursor/rules/code-comments-changelog.mdc）：
//  1. 勿手改 types.go 中的 member 类型注释——下次 make api-system 会被覆盖
//  2. 在 .api 源文件补充类型说明（块注释）与字段行尾注释（// ...）
//  3. 执行 make api-system 重新生成 types.go
//  4. 写操作（PUT/POST/DELETE）须在 .api 声明 returns，handler 用 httpx.OkJsonCtx 返回 data；
//     httpx.Ok 无 JSON body，前端 alova 会判定失败且弹窗无法关闭
//
// 契约与 JSON 示例：docs/biz-api.md 第 1 章（1.1～1.8、1.5.1 流水）
// 数据表映射：FbMemberDal（app/system/internal/dal/fb_member.go）
package types
