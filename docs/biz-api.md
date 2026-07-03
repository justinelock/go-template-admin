# 业务 API 接口文档

本文档汇总**用户管理 → K线管理**各业务子页的列表/统计接口。字段定义以 `desc/system/api/` 下 `.api` 文件为准；**如何从契约跟读到 Handler/Logic/DAL** 见 [read-api-flow.md](./read-api-flow.md)。

> **维护说明**：每个接口下方预留「响应示例」代码块，后续补充含真实字段值的完整 JSON。

## 通用约定

| 项 | 说明 |
| --- | --- |
| 服务 | `system`（本地默认 `http://127.0.0.1:8086`，含 `/auth/*` 与业务 API） |
| 网关 | Traefik 可选 `http://127.0.0.1:28080`；前端 Vite 代理 `/api` → 网关 |
| 鉴权 | 需登录 Token；中间件：`Auth`、`Sign` |
| 分页参数 | 所有列表接口继承 `PageReq`：`pageNum`、`pageSize`、`params[beginTime]`、`params[endTime]`（见下节默认值） |

### API 命名约定

| 层级 | 约定 |
| --- | --- |
| URL 前缀 | `/member/*`、`/fund/*`、`/trade/*` 等业务域 |
| 列表分页 | `GET …/list` + `PageReq`（`pageNum`、`pageSize`） |
| 统计 | `GET …/stats`，返回标量汇总（在 `data` 内） |
| 写操作 | 动词路径，camelCase（如 `addOrSubtract`、`openOrClose`） |
| Handler | goctl `@handler`：`PageSet`、`Stats`、`Flow` 等动词短语 |
| Logic | `{资源}Logic` + 动词方法（如 `StatsLogic.Stats`） |
| 契约类型 | `Member*Item` / `*Resp` / `*Req` |
| DAL | `Fb*Dal` 对应 `fb_*` 表；多表聚合可用 `FbMemberDal` |

### 分页请求默认参数

所有**列表分页** `GET` 请求，默认携带查询参数：

```text
pageNum=1&pageSize=10
```

示例（用户列表）：

```http
GET /member/user/list?pageNum=1&pageSize=10
```

| 参数 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- |
| `pageNum` | int | `1` | 当前页码，从 1 开始 |
| `pageSize` | int | `10` | 每页条数；前端 VxeGrid 全局默认 10（`adapter/vxe-table.ts`） |
| `params[beginTime]` | string | 无 | 筛选开始时间，可选 |
| `params[endTime]` | string | 无 | 筛选结束时间，可选 |

> **说明**：各接口还可叠加业务筛选参数（如 `keyword`、`status`）。团队统计 `GET /member/team/stats` **非分页**，无 `pageNum`/`pageSize`。若直接调后端且省略 `pageSize`，`desc/system/api/base.api` 中 go-zero 默认值为 `20`，与前端列表页实际传参可能不一致，联调时建议显式传 `pageSize=10`。

### 分页列表响应结构

含 `rows` 字段的响应由 `toolkit/helper/resp.go` **展平**到顶层（`rows` 不在 `data` 内）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

### 非分页对象响应结构

不含 `rows` 的响应包在 `data` 内，例如团队统计：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

## 接口总览

| 模块 | 页面 | 方法 | 路径 | 权限标识 |
| --- | --- | --- | --- | --- |
| 用户管理 | 用户列表 | GET | `/member/user/list` | `member:list:list` |
| 用户管理 | 活跃用户统计 | GET | `/member/user/stats` | `member:list:list` |
| 用户管理 | 实名认证 | GET | `/member/kyc/list` | `member:kyc:list` |
| 用户管理 | 钱包管理 | GET | `/member/wallet/list` | `member:wallet:list` |
| 用户管理 | 钱包加减款 | PUT | `/member/wallet/addOrSubtract` | `member:wallet:list` |
| 用户管理 | 钱包删除 | DELETE | `/member/wallet/{ids}` | `member:wallet:list` |
| 用户管理 | 用户报表 | GET | `/member/report/list` | `member:report:list` |
| 用户管理 | 报表流水 | GET | `/member/report/flow/{userId}` | `member:report:list` |
| 用户管理 | 团队管理 | GET | `/member/team/list` | `member:team:list` |
| 用户管理 | 团队统计 | GET | `/member/team/stats` | `member:team:list` |
| 用户管理 | 团队详情 | GET | `/member/team/{id}` | `member:team:list` |
| 用户管理 | 下级团队 | GET | `/member/team/members/{userId}` | `member:team:list` |
| 用户管理 | 更换上级 | PUT | `/member/team/changeParent` | `member:team:list` |
| 用户管理 | 代理层级 | PUT | `/member/team/agentLevel` | `member:team:list` |
| 用户管理 | 登录记录 | GET | `/member/loginLog/list` | `member:loginLog:list` |
| 资金管理 | 钱包申请 | GET | `/fund/walletApply/list` | `fund:walletApply:list` |
| 资金管理 | 钱包申请详情 | GET | `/fund/walletApply/detail/{id}` | `fund:walletApply:list` |
| 资金管理 | 钱包申请流水 | GET | `/fund/walletApply/flow/currentMonth` | `fund:walletApply:list` |
| 资金管理 | 钱包申请登录记录 | GET | `/fund/walletApply/loginLog/{userId}` | `fund:walletApply:list` |
| 资金管理 | 账户流水 | GET | `/fund/statement/list` | `fund:statement:list` |
| 资金管理 | 账户流水详情 | GET | `/fund/statement/detail/{id}` | `fund:statement:list` |
| 资金管理 | 提现管理 | GET | `/fund/withdraw/list` | `fund:withdraw:list` |
| 资金管理 | 提现批准 | PUT | `/fund/withdraw/approved/{id}` | `fund:withdraw:list` |
| 资金管理 | 提现拒绝 | PUT | `/fund/withdraw/rejected` | `fund:withdraw:list` |
| 资金管理 | 充值管理 | GET | `/fund/recharge/list` | `fund:recharge:list` |
| 订单管理 | 合约订单 | GET | `/trade/contract/list` | `trade:contract:list` |
| 订单管理 | 委托订单 | GET | `/trade/entrust/list` | `trade:entrust:list` |
| 订单管理 | 成交订单 | GET | `/trade/deal/list` | `trade:deal:list` |
| 投信管理 | 持仓订单 | GET | `/invest/position/list` | `invest:position:list` |
| 投信管理 | 收益订单 | GET | `/invest/position/order/list` | `invest:position:list` |
| 投信管理 | 修改前收益查询 | POST | `/invest/position/profit/before` | `invest:position:list` |
| 投信管理 | 修改持仓收益 | PUT | `/invest/position/profit` | `invest:position:list` |
| 投信管理 | 投信列表 | GET | `/invest/list/list` | `invest:list:list` |
| 投信管理 | 投信详情 | GET | `/invest/list/{id}` | `invest:list:list` |
| 投信管理 | 投信新增 | POST | `/invest/list` | `invest:list:list` |
| 投信管理 | 投信修改 | PUT | `/invest/list` | `invest:list:list` |
| 投信管理 | 投信删除 | DELETE | `/invest/list/{ids}` | `invest:list:list` |
| 产品管理 | 产品配置 | GET | `/product/config/list` | `product:config:list` |
| 产品管理 | 产品配置详情 | GET | `/product/config/{id}` | `product:config:list` |
| 产品管理 | 产品配置新增 | POST | `/product/config` | `product:config:list` |
| 产品管理 | 产品配置修改 | PUT | `/product/config` | `product:config:list` |
| 产品管理 | 产品配置删除 | DELETE | `/product/config/{ids}` | `product:config:list` |
| 产品管理 | 产品实时数据 | GET | `/product/realtime/list` | `product:realtime:list` |
| 产品管理 | 产品历史数据 | GET | `/product/history/list` | `product:history:list` |
| 通知管理 | 市场新闻 | GET | `/notify/news/list` | `notify:news:list` |
| 通知管理 | 市场新闻详情 | GET | `/notify/news/{id}` | `notify:news:list` |
| 通知管理 | 市场新闻新增 | POST | `/notify/news` | `notify:news:list` |
| 通知管理 | 市场新闻修改 | PUT | `/notify/news` | `notify:news:list` |
| 通知管理 | 通知发布 | GET | `/notify/publish/list` | `notify:publish:list` |
| K线管理 | K线管理 | GET | `/kline/main/list` | `kline:main:list` |
| App管理 | App品牌资源 | GET | `/app/brand/active` | `appBrand:main:list` |
| App管理 | App品牌资源保存 | PUT | `/app/brand` | `appBrand:main:list` |
| App管理 | App品牌图片上传 | POST | `/app/brand/upload/image` | `appBrand:main:list` |
| App管理 | App版本管理 | GET | `/app/version/active` | `appVersion:main:list` |
| App管理 | App版本保存 | PUT | `/app/version` | `appVersion:main:list` |
| App管理 | App安装包上传选项 | GET | `/app/release/upload/options` | `appVersion:main:list` |
| App管理 | App安装包上传 | PUT | `/app/release/upload` | `appVersion:main:list` |
| 仪表盘 | 分析页统计 | GET | `/dashboard/statistics` | 登录即可（分析页路由） |

---

## 一、用户管理

### 1.1 用户列表

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/user/list` |
| 权限 | `member:list:list` |
| API 定义 | `desc/system/api/member/user.api` |
| 行实体 | `MemberUserItem` |

**查询参数**（除分页外）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 关键词 |
| `authStatus` | string | 认证状态 |
| `deleted` | string | 是否已删用户 |

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `username` | string | 用户名 |
| `realName` | string | 真实姓名 |
| `idCard` | string | 身份证号 |
| `agentLevel` | int64 | 代理层级 |
| `inviteCode` | string | 邀请码 |
| `commissionRate` | float64 | 佣金比例 |
| `totalCommission` | float64 | 累计佣金 |
| `totalBalance` | float64 | 总余额（USD 钱包 `balance>0` 汇总） |
| `fundPositionAmount` | float64 | 投信持仓（`fb_fund_position` PENDING 本金） |
| `fundPositionDividend` | float64 | 投信分红（`fb_fund_profit_log.status=1` 汇总） |
| `status` | string | 账号状态 |
| `onlineStatus` | int64 | 在线状态（1=Redis token 在线或近 5 分钟 presence 活跃 / 0 离线） |
| `lastLogin` | string | 最后登录时间 |
| `createdAt` | string | 注册时间 |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2069776834893524993",
      "username": "13800138000",
      "realName": "马小梅",
      "idCard": "610623197011190122",
      "agentLevel": 3,
      "inviteCode": "X4A6B6LM",
      "commissionRate": 0.00,
      "totalCommission": 0.00,
      "totalBalance": 2244.60,
      "fundPositionAmount": 1000.0000,
      "fundPositionDividend": 30.0000,
      "status": "ACTIVE",
      "onlineStatus": 1,
      "lastLogin": "2026-06-24 21:37:37",
      "createdAt": "2026-06-24 21:37:07" 
    }
  ]
}

```

#### 1.1.1 删除用户

| 项 | 值 |
| --- | --- |
| 方法 | `DELETE` |
| 路径 | `/member/user/{ids}` |
| 权限 | `member:list:list` |
| API 定义 | `desc/system/api/member/user.api` |

**路径参数**：`ids` — 用户 id，多个用英文逗号分隔（如 `653` 或 `653,654`）。

**行为**：逻辑删除，设置 `fb_users.flag = 1`（仅 `flag=0` 的用户可删）。

#### 1.1.2 恢复已删用户

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/user/restore/{ids}` |
| 权限 | `member:list:list` |

**路径参数**：`ids` — 用户 id，逗号分隔。

**行为**：将 `fb_users.flag` 置为 `0`（仅 `flag=1` 的用户可恢复）。

#### 1.1.3 重置密码

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/user/resetPwd` |
| 权限 | `member:list:list` |
| API 定义 | `desc/system/api/member/user.api` |

**请求体**（`MemberUserResetPwdReq`）：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 用户 id |
| `password` | string | 新密码（5～20 位）；空则默认 `123456` |
| `type` | int64 | `1`=登录密码（默认），`2`=交易密码 |

**行为**：明文密码经 MD5 后写入 `fb_users.password` 或 `pay_password`。

#### 1.1.4 用户详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/user/{id}` |
| 权限 | `member:list:list` |
| 响应实体 | `MemberUserInfoResp`（在 `data` 内） |

**路径参数**：`id` — 用户主键。

**说明**：返回 `fb_users` 可展示字段（不含 `password`/`pay_password` 哈希）；含上级摘要 `parent`、USD 钱包汇总、投信持仓/分红、`onlineStatus`（Redis）。

**`data` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 用户 ID |
| `username` | string | 用户名 |
| `email` / `mobile` / `phone` | string | 联系方式 |
| `realName` / `idCard` | string | 实名信息 |
| `verificationStatus` / `verified` | string / bool | 实名认证 |
| `creditScore` | int64 | 信用分 |
| `securityQuestion` / `securityAnswer` | string | 密保 |
| `role` | string | 用户角色 |
| `accountLocked` / `failedAttempts` | bool / int64 | 锁定与登录失败次数 |
| `lastLogin` | string | 最后登录时间 |
| `parentId` | string | 上级代理 ID |
| `parent` | object | `{ id, username, realName }` |
| `level` / `agentLevel` | int64 | 代理等级 / 团队层级 |
| `inviteCode` | string | 邀请码 |
| `commissionRate` / `totalCommission` | float64 | 佣金 |
| `teamSize` | int64 | 团队规模 |
| `status` / `contractControl` | string / int64 | 账号状态 / 合约控制 |
| `isOnline` | string | 库内在线标记 |
| `remark` | string | 说明 |
| `flag` / `isTest` | int64 / bool | 删除标记 / 测试号 |
| `hasPassword` / `hasPayPassword` | bool | 是否已设登录/交易密码 |
| `payPasswordUpdatedAt` 等 | string / int64 | 交易密码相关时间/次数 |
| `avatar` | string | 头像（base64，可能较长） |
| `totalBalance` | float64 | USD 钱包余额汇总 |
| `fundPositionAmount` / `fundPositionDividend` | float64 | 投信持仓/分红 |
| `onlineStatus` | int64 | Redis 在线状态 1/0 |
| `createdAt` / `updatedAt` | string | 创建/更新时间 |

#### 1.1.5 保存用户编辑

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/user` |
| 权限 | `member:list:list` |

**请求体**（`MemberUserUpdateReq`）：与详情字段一致，另支持 `password`、`payPassword`（非空时 MD5 更新）、`avatar`（非空时更新 base64/data URL）。`username`、`realName`、`idCard`、`status` 必填；`username`、`idCard` 变更时服务端判重（唯一索引 `uk_username`、`id_id_card`），冲突返回业务错误。

**业务错误**：`用户名已经存在` / `身份证号已经存在`

---

### 1.2 用户列表（活跃统计）

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `GET /member/user/stats` |
| 权限 | `member:list:list` |
| API 定义 | `desc/system/api/member/user.api` |
| 响应实体 | `MemberUserStatsResp`（在 `data` 内） |

**查询参数**：无业务筛选（全局 Redis 统计，与列表 keyword 等无关）；**无分页参数**。

**`data` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `totalOnlineUsers` | int64 | Redis `online:user:*` 有效会话用户数 |
| `todayLogins` | int64 | Redis `login:today` Set 大小（今日登录用户） |
| `totalActiveSessions` | int64 | Redis `fb:presence:active` 近 **5 分钟**内有鉴权请求的活跃用户数；前端 Tag「活跃用户:{totalActiveSessions}」 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "totalOnlineUsers": 355,
    "todayLogins": 399,
    "totalActiveSessions": 2
  }
}
```

---

### 1.3 实名认证

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/kyc/list` |
| 权限 | `member:kyc:list` |
| API 定义 | `desc/system/api/member/kyc.api` |
| 行实体 | `MemberKycItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机号/姓名/身份证号模糊（`u.username`、`u.mobile`、`u.real_name`、`v.id_card_no`） |
| `authStatus` | string | 认证状态，映射 `v.status`（`VERIFIED` / `PENDING` / `REJECTED` 等） |
| `idCardNo` | string | 身份证号精确匹配 `v.id_card_no` |
| `username` | string | 用户名模糊 |
| `realName` | string | 实名表 `v.real_name` 模糊 |
| `params[beginTime]` / `params[endTime]` | string | 提交时间范围；**同时传**时 `v.created_at BETWEEN` |

**查询逻辑**：`fb_identity_verify v LEFT JOIN fb_users u ON u.id = v.user_id`，`ORDER BY v.created_at DESC`；`realName` 列来自 `u.real_name`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `idCardNo` | string | 身份证号 |
| `idCardFront` | string | 身份证正面 |
| `idCardBack` | string | 身份证反面 |
| `status` | string | 认证状态 |
| `rejectReason` | string | 驳回原因 |
| `verifiedAt` | string | 认证时间 |
| `createdAt` | string | 提交时间 |
| `updatedAt` | string | 更新时间 |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2067908255562674177",
      "userId": "2067908054152196097",
      "username": "13800138000",
      "mobile": null,
      "realName": "测试吧吧",
      "idCardNo": "220724199803123045",
      "idCardFront": "/ids/3efabddbb0454a64a8a51717cc343f86_2067908054152196097_front.jpeg",
      "idCardBack": "/ids/3efabddbb0454a64a8a51717cc343f86_2067908054152196097_back.jpeg",
      "status": "VERIFIED",
      "rejectReason": null,
      "verifiedAt": "2026-06-19 17:52:18",
      "createdAt": "2026-06-19 17:52:03",
      "updatedAt": "2026-06-19 17:52:18"
    }
  ]
}
```

---

### 1.3.1 实名认证-审核

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/kyc/verify` |
| 权限 | `member:kyc:list` |
| Java 对照 | `PUT /fubang/fbidentityverify/verify` |
| API 定义 | `desc/system/api/member/kyc.api` |

**请求体**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 认证主键 `fb_identity_verify.id` |
| `state` | string | `VERIFIED` 通过，`REJECTED` 拒绝（`APPROVED` 视为通过） |
| `remark` | string | `REJECTED` 时必填，写入 `reject_reason` |

**说明**：仅 `PENDING` 可审；通过时 `status=VERIFIED` 并同步 `fb_users.verified=1`、`real_name`、`id_card`。

---

### 1.4 钱包管理

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/wallet/list` |
| 权限 | `member:wallet:list` |
| API 定义 | `desc/system/api/member/wallet.api` |
| 行实体 | `MemberWalletItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `userId` | string | 用户 id（`w.user_id`，抽屉必传） |
| `keyword` | string | 用户名/手机号/真实姓名模糊 |
| `accountType` | string | 账户类型，映射 `w.account_type` |
| `status` | string | 用户状态 `u.status` |
| `verified` | string | 认证状态 `u.verified` |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `currency` | string | 币种（Go 扩展） |
| `frozenStatus` | string | 冻结状态（Go 扩展） |
| `params[beginTime]` / `params[endTime]` | string | 创建时间区间（同时传时用 BETWEEN） |

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `accountType` | string | 账户类型 |
| `balance` | float64 | 余额 |
| `frozenAmount` | float64 | 冻结金额 |
| `frozen` | bool | 是否冻结 |
| `version` | string | 乐观锁版本 |
| `currency` | string | 币种 |
| `drawTicket` | int64 | 抽奖券数量 |
| `createdAt` | string | 创建时间 |
| `updatedAt` | string | 更新时间 |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2068980123812048897",
      "userId": "2068980122423734274",
      "username": "FDD123",
      "mobile": null,
      "realName": "冯吕彬",
      "accountType": "main",
      "balance": 2244.60,
      "frozenAmount": 0.00,
      "frozen": false,
      "version": "3",
      "currency": "USD",
      "drawTicket": 0,
      "createdAt": "2026-06-22 16:51:16",
      "updatedAt": "2026-06-24 21:47:24"
    }
  ]
}
```

#### 1.4.1 钱包加减款

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/wallet/addOrSubtract` |
| 权限 | `member:wallet:list`（待细化为 update 权限） |
| API 定义 | `desc/system/api/member/wallet.api` |

**请求体**（`MemberWalletAddOrSubtractReq`）：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 钱包 id（`fb_user_wallets.id`） |
| `type` | bool | `true`=加款，`false`=减款 |
| `amount` | float64 | 金额（正数，服务端取绝对值） |
| `remark` | string | 备注；空则默认「后台调整加/减款」 |
| `flowType` | string | 加款：`ADD_AMOUNT`/`ADD_BONUS`/`ADD_DIVIDEND`/`ADD_TRANSFER`；减款：`SUBTRACT_AMOUNT`/`ADD_TRANSFER` |

**行为**：

- `type=true`：调用 `FbUserWalletDal.AddBalance`，更新余额并写入 `fb_account_flow_records`
- `type=false`：调用 `FbUserWalletDal.ReduceBalance`，校验余额后扣款并写流水

**请求示例**：

```json
{
  "id": "9",
  "type": true,
  "amount": 100.5,
  "remark": "活动补款",
  "flowType": "ADD_BONUS"
}
```

**响应**：`{ "code": 200, "msg": "操作成功" }`（与通知公告等 PUT 接口一致）

#### 1.4.2 钱包删除

| 项 | 值 |
| --- | --- |
| 方法 | `DELETE` |
| 路径 | `/member/wallet/{ids}` |
| 权限 | `member:wallet:list` |
| API 定义 | `desc/system/api/member/wallet.api` |

**路径参数**：`ids` 为钱包主键，多个用英文逗号分隔（`fb_user_wallets.id`）。

**行为**：物理删除 `fb_user_wallets` 记录（对齐 Java `DELETE /fubang/fbuserwallets`）。

**响应**：`{ "code": 200, "msg": "操作成功" }`

---

### 1.5 用户报表

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/report/list` |
| 权限 | `member:report:list` |
| API 定义 | `desc/system/api/member/report.api` |
| 行实体 | `MemberReportItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机号/真实姓名**精确**匹配（`u.username` / `u.mobile` / `u.real_name`） |
| `level` | string | 用户等级 `u.level` |
| `status` | string | 用户状态 `u.status` |
| `verified` | string | 认证状态 `u.verified` |
| `orderField` | string | 排序字段：`created_at`（默认）/ `last_login` / `level` / `username` |
| `order` | string | `asc` / `desc`，默认 `desc` |
| `params[beginTime]` / `params[endTime]` | string | 注册时间范围；**同时传**时 `u.created_at BETWEEN` |

**查询逻辑**：阶段 1 分页查 `fb_users`（`flag=0`）；阶段 2 对当前页 `userIds` 批量聚合（对齐 Java `FbUserReportServiceImpl.getPageData`）：

| 响应字段 | 数据来源 |
| --- | --- |
| `amount` | `fb_user_wallets` `SUM(balance)` |
| `rechargeAmount` | `fb_deposits` `status='SUCCESS'` `SUM(amount)` |
| `withdrawAmount` | `fb_withdraws` `status='SUCCESS'` `SUM(amount)` |
| `rechargeDiff` | `rechargeAmount - withdrawAmount` |
| `totalProfit` | `fb_profit_records` `SUM(amount)` |
| `teamCount` | `fb_users` 直属下级 `parent_id IN (...)` 且 `flag=0` |
| `loginIp` | `fb_device_login_log` 按 `MAX(login_time)` 取最近 IP |
| `parentUser` | `fb_users` 按 `parent_id` 批量查上级 |

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `level` | int64 | 等级 |
| `amount` | float64 | 账户余额 |
| `rechargeAmount` | float64 | 累计充值 |
| `withdrawAmount` | float64 | 累计提现 |
| `rechargeDiff` | float64 | 充提差 |
| `totalProfit` | float64 | 累计盈亏（`fb_profit_records`） |
| `teamCount` | int64 | 直属下级人数（非 `team_size`） |
| `registerTime` | string | 注册时间 |
| `lastLogin` | string | 最后登录 |
| `loginIp` | string | 登录 IP |
| `parentUser` | object | 上级用户 `{ id, username }` |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2068980122423734274",
      "userId": "2068980122423734274",
      "username": "FDD123",
      "mobile": null,
      "realName": "冯吕彬",
      "level": 0,
      "amount": 2244.60,
      "rechargeAmount": 3000.00,
      "withdrawAmount": 0,
      "rechargeDiff": 3000.00,
      "totalProfit": 0,
      "teamCount": 0,
      "registerTime": "2026-06-22 16:51:16",
      "lastLogin": "2026-06-25 00:46:45",
      "loginIp": "223.104.72.141",
      "parentUser": {
        "id": "2000844918397870081",
        "username": "wu52886"
      }
    }
  ]
}
```

### 1.5.1 用户报表流水

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/report/flow/{userId}` |
| 权限 | `member:report:list` |
| API 定义 | `desc/system/api/member/report.api` |
| 行实体 | `MemberReportFlowItem` |

**路径参数**：`userId` — 业务用户 ID。

**查询参数**（对齐 Java `fbaccountflowrecords/page`）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `status` | string | 交易状态 `f.status` |
| `type` | string | 交易类型 `f.flow_type` |
| `keyword` | string | 用户名/手机/姓名/业务单号模糊 |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `params[beginTime]` / `params[endTime]` | string | 交易时间范围；同时传时 `f.created_at BETWEEN` |

**查询逻辑**：`fb_account_flow_records f LEFT JOIN fb_users u`，`ORDER BY f.created_at DESC`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `accountType` | string | 账户类型 |
| `flowType` | string | 流水类型 |
| `beforeAmount` | float64 | 变动前余额 |
| `flowAmount` | float64 | 变动金额 |
| `afterAmount` | float64 | 变动后余额 |
| `businessNo` | string | 业务单号 |
| `remark` | string | 备注 |
| `createdAt` | string | 创建时间 |
| `walletId` | string | 钱包 ID |
| `currency` | string | 币种 |
| `description` | string | 描述 |
| `status` | string | 状态 |
| `updatedAt` | string | 更新时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2069775650615013378",
      "userId": "2068980122423734274",
      "username": "FDD123",
      "mobile": null,
      "realName": "冯吕彬",
      "accountType": "main",
      "flowType": "CONTRACT_BUY",
      "beforeAmount": 2229.00,
      "flowAmount": -2229.00,
      "afterAmount": 0.00,
      "businessNo": "CONTRACT_BUY_2069775650594041858",
      "remark": "购买ETH/EUR合约",
      "createdAt": "2026-06-24 21:32:24",
      "walletId": "2068980123812048897",
      "currency": "USD",
      "description": "购买ETH/EUR合约",
      "status": "SUCCESS",
      "updatedAt": null
    }
  ]
}
```

---

### 1.6 团队管理（列表）

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/team/list` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| 行实体 | `MemberTeamItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机号/用户 ID |
| `status` | string | 用户状态 `fb_users.status` |
| `params[beginTime]` / `params[endTime]` | string | 注册时间范围；**同时传**时 `u.created_at BETWEEN` |

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `username` | string | 用户名 |
| `agent` | object | 上级代理 `{ id, username, realName }` |
| `realName` | string | 真实姓名 |
| `level` | int64 | 用户等级 |
| `status` | string | 状态 |
| `teamSize` | int64 | 团队规模 |
| `level1Members` ~ `level5Members` | int64 | 各级成员数 |
| `agentLevel` | int64 | 代理层级 |
| `walletCount` | int64 | 钱包数量 |
| `balance` | float64 | 个人余额 |
| `totalTeamBalance` | float64 | 团队总余额 |
| `createdAt` | string | 注册时间 |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2068980122423734274",
      "username": "FDD123",
      "agent": {
        "id": "2000844918397870081",
        "username": "wu52886",
        "realName": "吴彩艳"
      },
      "realName": "冯吕彬",
      "level": 0,
      "status": "ACTIVE",
      "teamSize": 0,
      "level1Members": 0,
      "level2Members": 0,
      "level3Members": 0,
      "level4Members": 0,
      "level5Members": 0,
      "agentLevel": 3,
      "walletCount": 0,
      "balance": 2244.60,
      "totalTeamBalance": 0,
      "createdAt": null 
    }
  ]
}
```

---

### 1.6.1 团队详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/team/{id}` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| 响应实体 | `MemberTeamDetailResp`（在 `data` 内） |

**路径参数**：`id` — 业务用户 ID（`fb_users.id`）。

**`data` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 用户 ID |
| `username` | string | 用户名 |
| `agentLevel` | int64 | 代理展开层级 3/4/5 |
| `walletCount` | int64 | 钱包数量 |
| `totalAssets` | float64 | 总资产（`fb_user_wallets` 余额汇总） |
| `totalDeposit` | float64 | 总充值（`fb_deposits` SUCCESS） |
| `totalWithdraw` | float64 | 总提现（`fb_withdraws` SUCCESS） |
| `createdAt` | string | 加入时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": "2070046854793998337",
    "username": "13800138000",
    "agentLevel": 3,
    "walletCount": 0,
    "totalAssets": 0.00,
    "totalDeposit": 0.00,
    "totalWithdraw": 0.00,
    "createdAt": "2026-01-15 10:20:00"
  }
}
```

---

### 1.6.2 下级团队成员

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/team/members/{userId}` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| 行实体 | `MemberTeamMemberItem` |

**路径参数**：`userId` — 根用户 ID（抽屉所属用户）。

**查询参数**：标准分页 `pageNum`、`pageSize`。

**查询逻辑**：递归查 `parent_id` 下级树；**最大深度**随根用户 `agent_level` 限制（对齐 Java `getSubTeamByUserIdPage`）：3=仅三级、4=含四级、5=含五级。`level` 为相对根用户的层级 1～N。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `level` | int64 | 相对层级 |
| `username` | string | 用户名 |
| `totalAssets` | float64 | 总资产（钱包余额汇总） |
| `totalDeposit` | float64 | 总充值 |
| `totalInvest` | float64 | 总投信（PENDING 投信本金） |
| `totalWithdraw` | float64 | 总提现 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 2,
  "rows": [
    {
      "level": 1,
      "username": "user_a",
      "totalAssets": 100.00,
      "totalDeposit": 500.00,
      "totalInvest": 200.00,
      "totalWithdraw": 50.00
    }
  ]
}
```

---

### 1.6.3 更换上级

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/team/changeParent` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| Java 对照 | `PUT /fubang/fbusers/changeAgent`（`AgentChangeRequest`） |

**请求体**（`MemberTeamChangeParentReq`）：

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `userId` | string | 是 | 被操作用户 `fb_users.id` |
| `username` | string | 是 | **新上级用户名**（按 `fb_users.username` 精确匹配，非 ID） |

**行为**：

- 按 `username` 查上级用户（`flag=0`），更新被操作用户的 `parent_id`
- 禁止将自己设为上级、禁止将下级设为上级（防环）

**错误提示**（业务码非 200）：`用户ID不能为空`、`上级代理用户名不能为空`、`用户不存在`（被操作用户或上级用户名不存在）、`不能将自己设为上级`、`不能将下级设为上级`

**请求示例**：

```json
{
  "userId": "2070046854793998337",
  "username": "wu52886"
}
```

**响应**（`MemberTeamChangeParentResp`，在 `data` 内）：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `userId` | string | 被操作用户 ID |
| `parentId` | string | 新上级用户 ID |
| `parentUsername` | string | 新上级用户名 |

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "userId": "2070046854793998337",
    "parentId": "2000844918397870081",
    "parentUsername": "wu52886"
  }
}
```

### 1.6.4 调整代理层级

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/member/team/agentLevel` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| Java 对照 | `PUT /fubang/fbusers/agentLevel`（`AgentLevelUpdateRequest`） |

**请求体**（`MemberTeamAgentLevelReq`）：

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `userId` | string | 是 | 被操作用户 `fb_users.id` |
| `agentLevel` | int64 | 是 | 团队最大展开层级，仅允许 `3` / `4` / `5` |

**行为**：更新 `fb_users.agent_level` 与 `updated_at`；影响该用户「下级团队」抽屉可见深度。

**错误提示**：`用户ID不能为空`、`代理层级必须为 3、4 或 5`、`用户不存在`

**请求示例**：

```json
{
  "userId": "653",
  "agentLevel": 4
}
```

**响应**（`MemberTeamAgentLevelResp`，在 `data` 内）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "userId": "653",
    "agentLevel": 4
  }
}
```

---

### 1.7 团队管理（统计）

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/team/stats` |
| 权限 | `member:team:list` |
| API 定义 | `desc/system/api/member/team.api` |
| Java 对照 | `GET /fubang/fbteam/stats`（`TeamServiceImpl.getTeamStatsAll`） |
| 响应实体 | `MemberTeamStatsResp`（在 `data` 内） |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 可选；模糊匹配 `username` / `mobile` / `id_card` / `real_name`，`LIMIT 1` 定位**统计根用户**；无 keyword 或无匹配时走**全局统计** |

> **注意**：stats **仅使用 `keyword`**，不使用 `status`、注册时间等列表筛选（与 Java 一致）。

**统计逻辑**（对齐 Java `getTeamStatsAll`）：

1. **无根用户**（无 keyword 或未匹配到用户）  
   - 人数：`parent_id IS NULL` 的顶层用户为 `level1Members`，其后代依次为 level2～5（`parent_id` 树 LEFT JOIN）  
   - 余额：`fb_user_wallets` 全库 `SUM(balance)`

2. **有根用户**（keyword 命中）  
   - 读取根用户 `agent_level` 并归一化为 3/4/5  
   - 人数：以该用户为根的子树统计（`level1`=直属下级 `l2`，…，`level5`=第五代 `l6`）  
   - 按 `agent_level` 截断：`agent_level<4` 时 `level4Members=0`；`<5` 时 `level5Members=0`，并重算 `totalMembers`  
   - 余额：仅汇总该用户 `agent_level` 深度内**全部下级**钱包余额（不含根用户本人）

**`level1Members` 语义**：

| 模式 | 含义 |
| --- | --- |
| 全局（无 keyword） | 顶层代理用户数（`parent_id IS NULL`） |
| 指定用户（有 keyword） | 该用户的直属下级人数 |

**`data` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `totalMembers` | int64 | 各级人数之和（截断后） |
| `level1Members` ~ `level5Members` | int64 | 相对团队树第 1～5 层人数 |
| `totalTeamBalance` | float64 | 全库或下级钱包余额总和 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "totalMembers": 29,
    "level1Members": 4,
    "level2Members": 5,
    "level3Members": 5,
    "level4Members": 5,
    "level5Members": 10,
    "totalTeamBalance": 790041.88
  }
}
```

---

### 1.8 登录记录

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/member/loginLog/list` |
| 权限 | `member:loginLog:list` |
| API 定义 | `desc/system/api/member/login_log.api` |
| 行实体 | `MemberLoginLogItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 关键词 |
| `loginResult` | string | 登录结果 |
| `loginMethod` | string | 登录方式 |
| `riskLevel` | string | 风险等级 |
| `ipType` | string | IP 类型 |
| `timeRange` | string | 时间范围 |
| `failReason` | string | 失败原因 |
| `deviceType` | string | 设备类型 |
| `browser` | string | 浏览器 |

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `realName` | string | 真实姓名 |
| `deviceId` | string | 设备 ID |
| `loginTime` | string | 登录时间 |
| `loginIp` | string | 登录 IP |
| `loginLocation` | string | 登录地点 |
| `loginType` | string | 登录方式 |
| `loginResult` | string | 登录结果 |
| `failReason` | string | 失败原因 |
| `riskLevel` | string | 风险等级 |
| `riskDetail` | string | 风险详情 |

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2069849388882669569",
      "userId": "2051263591276912641",
      "username": "13800138000",
      "realName": "abc",
      "deviceId": "4d2e6539d2b783c3bf1f886344fdca1e",
      "loginTime": "2026-06-25 02:25:25",
      "loginIp": "111.19.76.126",
      "loginLocation": "Unknown",
      "loginType": "PASSWORD",
      "loginResult": "SUCCESS",
      "failReason": null,
      "riskLevel": "LOW",
      "riskDetail": null
    }
  ]
}
```

---

## 二、资金管理

### 2.1 钱包申请（列表）

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/walletApply/list` |
| 权限 | `fund:walletApply:list` |
| API 定义 | `desc/system/api/fund/wallet_apply.api` |
| Java 对照 | `GET /fubang/fbaccountapplication/page` |
| 行实体 | `FundWalletApplyItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机/姓名模糊 |
| `status` | string | `a.status`：`PENDING` / `APPROVED` / `REJECTED` |
| `state` | string | `a.state` |
| `verified` | string | `u.verified` |
| `userId` | string | `a.user_id` 精确 |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `accountType` | string | 账户类型 `main` / `fund` / `forex` 等 |
| `params[beginTime]` / `params[endTime]` | string | 创建时间范围；同时传时 `a.created_at BETWEEN` |

**查询逻辑**：`fb_account_application a LEFT JOIN fb_users u LEFT JOIN sys_user su`（审核人 `su.user_id = CAST(a.audit_user_id AS CHAR)`，`auditUser` 取 `su.username`），`ORDER BY a.created_at DESC`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 申请主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `accountType` | string | 账户类型 |
| `status` | string | 审核状态 |
| `state` | string | 状态副本 |
| `riskAssessmentScore` | int64 | 风险评估分 |
| `rejectReason` | string | 拒绝原因/审核意见 |
| `applyTime` | string | 申请时间 |
| `auditTime` | string | 审核时间 |
| `auditUserId` | string | 审核人 ID |
| `auditUser` | string | 审核人账号 |
| `remark` | string | 备注 |
| `createdAt` / `updatedAt` | string | 创建/更新时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [{
    "id": "2070129356581711873",
    "userId": "2021488651577335809",
    "username": "mm78928",
    "mobile": null,
    "realName": "abc",
    "accountType": "fund",
    "status": "APPROVED",
    "state": "APPROVED",
    "riskAssessmentScore": 18,
    "rejectReason": "1111111",
    "applyTime": "2026-06-25 20:57:54",
    "auditTime": "2026-06-25 21:01:46",
    "auditUserId": "2004024338266054657",
    "auditUser": "admin",
    "remark": null,
    "createdAt": "2026-06-25 20:57:54",
    "updatedAt": "2026-06-25 21:01:46"
  }]
}
```

---

### 2.1.1 钱包申请-详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/walletApply/detail/{id}` |
| 权限 | `fund:walletApply:list` |
| Java 对照 | `GET /fubang/fbaccountapplication/detail/{id}` |
| 响应实体 | `FundWalletApplyDetailResp`（在 `data` 内） |

**路径参数**：`id` — 申请主键 `fb_account_application.id`。

**`data` 结构**：

| 块 | 字段 | 说明 |
| --- | --- | --- |
| `basicInfo` | `id`、`username`、`accountType`、`riskAssessmentScore`、`status`、`applyTime`、`auditTime`、`rejectReason`、`remark` | 申请基本信息 |
| `securityInfo` | `twoFactorEnabled`、`securityScore`、`identityVerified` | 安全认证（对齐 Java `calculateSecurityScore`） |
| `loginStats` | `commonLoginIp`、`lastLoginTime`、`commonLoginArea`、`monthLoginCount` | 登录统计 |
| `flowStats` | `tradeSuccessRate`、`monthFlowCount`、`dailyAvgAmount`、`monthIncome`、`monthExpense`、`typeStatsMap` | 当月流水统计 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": null,
    "userId": null,
    "basicInfo": {
      "id": "2070129356581711873",
      "username": "mm78928",
      "accountType": "fund",
      "riskAssessmentScore": 18,
      "status": "APPROVED",
      "applyTime": "2026-06-25 20:57:54",
      "auditTime": "2026-06-25 21:01:46",
      "rejectReason": "1111111",
      "remark": null
    },
    "securityInfo": {
      "twoFactorEnabled": false,
      "securityScore": 20,
      "identityVerified": true
    },
    "loginStats": {
      "commonLoginIp": "112.46.214.6",
      "lastLoginTime": "2026-06-25 21:23:02",
      "commonLoginArea": "112.46.214.6",
      "monthLoginCount": 94
    },
    "flowStats": {
      "tradeSuccessRate": "100.00",
      "monthFlowCount": 80,
      "dailyAvgAmount": 2559.28,
      "monthIncome": 32905.38,
      "monthExpense": 33636.00,
      "typeStatsMap": {
        "CONTRACT_PROFIT": 39,
        "CONTRACT_BUY": 39,
        "DEPOSIT": 1,
        "PURCHASE": 1
      }
    }
  }
}
```

---

### 2.1.2 钱包申请-最近流水

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/walletApply/flow/currentMonth` |
| 权限 | `fund:walletApply:list` |
| Java 对照 | `GET /fubang/fbaccountflowrecords/getCurrentMonthList` |
| 行实体 | `FundWalletApplyFlowItem` |

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `userId` | string | 申请人 `fb_users.id`（必填） |

**说明**：返回**当月全量**流水（`created_at >= 当月 1 日 00:00:00`），**不分页**；`total` 为 `rows` 条数，便于 VxeGrid 无分页展示。

**抽屉标题**：`{realName}的最近流水`（无 `realName` 时回退 `username`）。

**表格列**：交易类型（`flowType`）、变动金额（`flowAmount`）、交易前余额（`beforeAmount`）、交易后余额（`afterAmount`）、交易状态（`status`）、交易描述（`description`）。

**`rows[]` 字段**：`id`、`userId`、`accountType`、`flowType`、`beforeAmount`、`flowAmount`、`afterAmount`、`businessNo`、`remark`、`createdAt`、`walletId`、`currency`、`description`、`status`、`updatedAt`。

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [{
    "id": "2070137374010585089",
    "userId": "2021488651577335809",
    "accountType": "main",
    "flowType": "PURCHASE",
    "beforeAmount": 1009.31,
    "flowAmount": -1009.00,
    "afterAmount": 0.31,
    "businessNo": "fd0fcfc760154819bd3c9fc0eca68d9e",
    "remark": "FUBON",
    "createdAt": "2026-06-24 21:32:24",
    "walletId": "2021488651615084545",
    "currency": "USD",
    "description": "投信购买",
    "status": "SUCCESS",
    "updatedAt": null
  }]
}
```

---

### 2.1.3 钱包申请-登录记录

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/walletApply/loginLog/{userId}` |
| 权限 | `fund:walletApply:list` |
| Java 对照 | `GET /fubang/fbdeviceloginlog/page` |
| 行实体 | `FundWalletApplyLoginLogItem` |

**路径参数**：`userId` — 申请人 `fb_users.id`（必填）。

**查询参数**：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `pageNum` / `pageSize` | int | 标准分页 |
| `status` | string | 登录结果，映射 `d.login_result` |
| `keyword` | string | 用户名/手机/姓名/登录 IP 模糊 |
| `username` | string | 用户名模糊 |
| `realName` | string | 真实姓名模糊 |
| `params[beginTime]` / `params[endTime]` | string | 登录时间范围；同时传时 `d.login_time BETWEEN` |

**查询逻辑**：`fb_device_login_log d LEFT JOIN fb_users u ON u.id = d.user_id AND d.user_id > 0`，`ORDER BY d.login_time DESC`。

**抽屉标题**：`{realName}的登录记录`。

**表格列**：登录时间、登录 IP、登录地点、登录方式、登录结果、失败原因、风险等级。

**`rows[]` 字段**：`id`、`userId`、`username`、`loginTime`、`loginIp`、`loginLocation`、`loginType`、`loginResult`、`failReason`、`riskLevel`、`riskDetail`。

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [{
    "id": "2070135678979092482",
    "userId": "2021488651577335809",
    "username": "mm78928",
    "loginTime": "2026-06-25 21:23:02",
    "loginIp": "112.46.213.221",
    "loginLocation": "Unknown",
    "loginType": "PASSWORD",
    "loginResult": "SUCCESS",
    "failReason": null,
    "riskLevel": "LOW",
    "riskDetail": null
  }]
}
```

---

### 2.1.4 钱包申请-审核

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/fund/walletApply/verify` |
| 权限 | `fund:walletApply:list` |
| Java 对照 | `PUT /fubang/fbaccountapplication/verify` |
| API 定义 | `desc/system/api/fund/wallet_apply.api` |

**请求体**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 申请主键 `fb_account_application.id` |
| `state` | string | `APPROVED` 通过，`REJECTED` 拒绝 |
| `remark` | string | 必填且至少 5 字，写入 `reject_reason`（通过/拒绝均写） |

**说明**：仅 `PENDING` 可审；通过时先补建 `main/USD`（非主账户申请），再按账户类型默认币种开通钱包，并更新 `status/state=APPROVED`、`audit_time`、`audit_user_id`。

---

### 2.2 账户流水

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/statement/list` |
| 权限 | `fund:statement:list` |
| API 定义 | `desc/system/api/fund/statement.api` |
| Java 对照 | `GET /fubang/fbaccountflowrecords/page` |
| 行实体 | `FundStatementItem` |

**查询参数**（对齐 Java `selectPageWithUser`）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机/姓名/业务单号模糊 |
| `status` | string | 交易状态 `f.status` |
| `type` | string | 交易类型 `f.flow_type` |
| `currency` | string | 币种 `f.currency` |
| `userId` | string | 用户 ID 精确 |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `params[beginTime]` / `params[endTime]` | string | 交易时间；同时传时 `f.created_at BETWEEN` |

**查询逻辑**：`fb_account_flow_records f LEFT JOIN fb_users u`，`ORDER BY f.created_at DESC`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 流水主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `accountType` | string | 账户类型 |
| `flowType` | string | 交易类型 |
| `beforeAmount` | float64 | 交易前余额 |
| `flowAmount` | float64 | 变动金额 |
| `afterAmount` | float64 | 交易后余额 |
| `businessNo` | string | 业务单号 |
| `remark` | string | 备注 |
| `createdAt` | string | 交易时间 |
| `walletId` | string | 钱包 ID |
| `currency` | string | 币种 |
| `description` | string | 交易描述 |
| `status` | string | 交易状态 |
| `updatedAt` | string | 更新时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [{
    "id": "2069393879385845762",
    "userId": "653",
    "username": "09612345678",
    "mobile": null,
    "realName": "杨阳洋",
    "accountType": "main",
    "flowType": "CONTRACT_PROFIT",
    "beforeAmount": 9628.87,
    "flowAmount": 40.00,
    "afterAmount": 9668.87,
    "businessNo": "a7392d6a-1419-4482-95e5-f032d1aa3a71",
    "remark": "合约盈利",
    "createdAt": "2026-06-23 20:15:23",
    "walletId": "1549",
    "currency": "USD",
    "description": "合约盈利",
    "status": "SUCCESS",
    "updatedAt": null
  }]
}
```

---

### 2.2.1 账户流水-详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/statement/detail/{id}` |
| 权限 | `fund:statement:list` |
| Java 对照 | `GET /fubang/fbaccountflowrecords/{id}` |
| 响应实体 | `FundStatementItem`（在 `data` 内） |

**路径参数**：`id` — 流水主键 `fb_account_flow_records.id`。

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": "2069393879385845762",
    "userId": "653",
    "accountType": "main",
    "flowType": "CONTRACT_PROFIT",
    "beforeAmount": 9628.87,
    "flowAmount": 40.00,
    "afterAmount": 9668.87,
    "businessNo": "a7392d6a-1419-4482-95e5-f032d1aa3a71",
    "remark": "合约盈利",
    "createdAt": "2026-06-23 20:15:23",
    "walletId": "1549",
    "currency": "USD",
    "description": "合约盈利",
    "status": "SUCCESS",
    "updatedAt": null
  }
}
```

---

### 2.3 提现管理

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/withdraw/list` |
| 权限 | `fund:withdraw:list` |
| API 定义 | `desc/system/api/fund/withdraw.api` |
| Java 对照 | `GET /fubang/fbwithdraws/page` |
| 行实体 | `FundWithdrawItem` |

**查询参数**（对齐 Java `selectPageWithUser`）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机/姓名/订单号模糊 |
| `status` | string | `w.status`：`PENDING` / `SUCCESS` / `REJECTED` |
| `type` | string | `w.withdraw_type`（Java 参数名 `type`） |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `params[beginTime]` / `params[endTime]` | string | 创建时间；同时传时 `w.created_at BETWEEN` |

**查询逻辑**：`fb_withdraws w LEFT JOIN fb_users u`，`ORDER BY w.created_at DESC`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 提现主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `orderNo` | string | 订单号 |
| `amount` | float64 | 提现金额 |
| `status` | string | 状态 |
| `withdrawType` | string | 提现类型 |
| `bankName` | string | 银行名称/链类型 |
| `bankCardNo` | string | 银行卡号/USDT 地址 |
| `accountName` | string | 开户名 |
| `paymentStatus` | string | 支付状态 |
| `paymentNo` | string | 支付流水号 |
| `paymentTime` | string | 支付时间 |
| `remark` | string | 备注 |
| `rejectReason` | string | 拒绝原因 |
| `createdAt` / `updatedAt` | string | 创建/更新时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2070128205987655681",
      "userId": "2035283111301906434",
      "username": "wm0529",
      "realName": "abc",
      "orderNo": "W1782392000086884a1e",
      "amount": 108.00,
      "status": "SUCCESS",
      "withdrawType": "USDT",
      "bankName": "TRC20",
      "bankCardNo": "TDLQEEs2tsj2eEFks1os7AH8mqiSjuVye2",
      "accountName": "TRC20",
      "paymentStatus": "SUCCESS",
      "paymentTime": "2026-06-25 21:02:55",
      "remark": "USDT提现  TRC20 TDLQEEs2tsj2eEFks1os7AH8mqiSjuVye2",
      "rejectReason": null,
      "createdAt": "2026-06-25 20:53:20",
      "updatedAt": "2026-06-25 21:02:55"
    }
  ]
}
```

---

### 2.3.1 提现管理-批准

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/fund/withdraw/approved/{id}` |
| 权限 | `fund:withdraw:list` |
| Java 对照 | `PUT /fubang/fbwithdraws/approved/{id}` |

**说明**：将 `status`、`payment_status` 置为 `SUCCESS`，写入 `payment_time`；仅非 `SUCCESS` 订单可批准。

---

### 2.3.2 提现管理-拒绝

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/fund/withdraw/rejected` |
| 权限 | `fund:withdraw:list` |
| Java 对照 | `PUT /fubang/fbwithdraws/rejected` |

**请求体**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 提现主键 |
| `remark` | string | 拒绝理由（必填，写入 `reject_reason`） |

**说明**：仅 `PENDING` 可拒绝；拒绝后退回主账户余额并写 `WITHDRAW_FAILED` 流水（`business_no = orderNo + _WITHDRAW_REFUND`）。

---

### 2.4 充值管理

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/fund/recharge/list` |
| 权限 | `fund:recharge:list` |
| API 定义 | `desc/system/api/fund/recharge.api` |
| Java 对照 | `GET /fubang/fbdeposits/page` |
| 行实体 | `FundRechargeItem` |

**查询参数**（对齐 Java `selectPageWithUser`）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机/姓名/订单号模糊 |
| `status` | string | `d.status`：`PENDING` / `REVIEWING` / `SUCCESS` / `CANCELLED` |
| `username` | string | 用户名模糊 |
| `mobile` | string | 手机号模糊 |
| `realName` | string | 真实姓名模糊 |
| `params[beginTime]` / `params[endTime]` | string | 创建时间；同时传时 `d.created_at BETWEEN` |

**查询逻辑**：`fb_deposits d LEFT JOIN fb_users u`，`ORDER BY d.created_at DESC`。

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 充值主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `orderNo` | string | 订单号 |
| `amount` | float64 | 充值金额 |
| `status` | string | 状态 |
| `paymentMethod` | string | 支付方式 |
| `paymentStatus` | string | 支付状态 |
| `paymentNo` | string | 支付流水号 |
| `paymentTime` | string | 支付时间 |
| `remark` | string | 备注/拒绝理由 |
| `currency` | string | 币种 |
| `targetAccount` | string | 目标账户（`MAIN` / `FOREX` 等） |
| `screenshot` | string | 充值截图路径 |
| `createdAt` / `updatedAt` | string | 创建/更新时间 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2067607428763561985",
      "userId": "2067602058431246337",
      "username": "chen258369",
      "mobile": null,
      "realName": "abc",
      "orderNo": "D17817909999280d1ca0",
      "amount": 1000.00,
      "status": "SUCCESS",
      "paymentMethod": "USDT",
      "paymentStatus": "SUCCESS",
      "paymentNo": null,
      "paymentTime": "2026-06-18 21:57:47",
      "remark": null,
      "currency": "USDT",
      "targetAccount": "MAIN",
      "screenshot": "/deposit/a479f238ff3147e3afabcb0f11f4fb94_D17817909999280d1ca0_USDT_USDT_MAIN.jpeg",
      "createdAt": "2026-06-18 21:56:40",
      "updatedAt": "2026-06-18 21:57:47"
    }
  ]
}
```

---

### 2.4.1 充值管理-批准

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/fund/recharge/approved/{id}` |
| 权限 | `fund:recharge:list` |
| Java 对照 | `PUT /fubang/fbdeposits/approved/{id}` |

**说明**：仅 `PENDING` / `REVIEWING` 可批准；先按 `userId` + `currency` + `targetAccount` 入账并写 `DEPOSIT` 流水（`business_no = orderNo`），再将 `status`、`payment_status` 置为 `SUCCESS`，写入 `payment_time`。

---

### 2.4.2 充值管理-拒绝

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/fund/recharge/rejected` |
| 权限 | `fund:recharge:list` |
| Java 对照 | `PUT /fubang/fbdeposits/rejected` |

**请求体**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 充值主键 |
| `remark` | string | 拒绝理由（必填，写入 `remark`） |

**说明**：仅 `PENDING` / `REVIEWING` 可拒绝；`status`、`payment_status` 置为 `CANCELLED`（充值未入账，不退款）。

---

## 三、订单管理

### 3.1 合约订单

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/trade/contract/list` |
| 权限 | `trade:contract:list` |
| API 定义 | `desc/system/api/trade/contract.api` |
| Java 对照 | `GET /fubang/fbcontractorders/page` |
| 行实体 | `TradeContractItem` |

**查询参数**（对齐 Java `getWrapper`）：

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `keyword` | string | 用户名/手机/姓名/身份证模糊 → `user_id` |
| `status` | string | `o.status`：1 持仓中 / 2 已取消 / 3 已结算 |
| `controlResult` | string | `1`/`2`：`control_result`；`3`：自然（`control_type IS NULL OR = 3`） |
| `type` | string | Java 列表未使用，保留兼容 |
| `params[beginTime]` / `params[endTime]` | string | 创建时间；同时传时 `o.create_time BETWEEN` |

**查询逻辑**：`fb_crypto_contract_orders`，`ORDER BY create_time DESC`。

**列表组装**（对齐 Java `getRecords`）：

- 批量查用户 `username` / `mobile` / `realName`
- `balance`：已结算且有 `walletBalanceAfterSettle` 用快照，否则汇总当前 USD 钱包余额
- `productName`：优先 `pairName`，旧单按 `coinType` 匹配 `fb_fund_product.name`
- `hasBoughtFund`：是否存在 `fb_fund_position` 进行中持仓（`state=PENDING` 且 `status=1`）

**`rows[]` 字段**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 订单主键 |
| `userId` | string | 用户 ID |
| `username` | string | 用户名 |
| `mobile` | string | 手机号 |
| `realName` | string | 真实姓名 |
| `account` | string | 用户账号 |
| `coinType` | string | 币种 |
| `market` | string | 市场 |
| `direction` | int | 1 买入做多 / 2 卖出做空 |
| `tradePair` | string | 交易对 |
| `pairName` | string | 交易对展示名 |
| `productName` | string | 列表展示用交易对文案 |
| `amount` | float64 | 交易金额 |
| `profitRatio` | float64 | 收益比例 |
| `seconds` | int | 合约时长(秒) |
| `openingPrice` / `closingPrice` | float64 | 开/平仓价格 |
| `openingTime` / `closingTime` | string | 开/平仓时间 |
| `balance` | float64 | 列表展示余额 |
| `walletBalanceAfterSettle` | float64 | 结算后余额快照 |
| `expectedProfit` / `actualProfit` | float64 | 预期/实际收益 |
| `status` | int | 1 持仓 / 2 取消 / 3 结算 |
| `controlType` | int | 1 必赢 / 2 必输 / 3 自然 |
| `controlResult` | int | 1 赢 / 2 输 |
| `remark` | string | 备注 |
| `createTime` / `updateTime` | string | 创建/更新时间 |
| `version` | int | 版本号 |
| `userControl` | int | 用户控单 |
| `globalControlStateSnapshot` | string | 当日全局控盘快照 |
| `globalControlApplied` | int | 全局控盘是否生效 |
| `hasBoughtFund` | int | 是否持有进行中投信 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2069151242346364929",
      "userId": "653",
      "username": "09612345678",
      "mobile": null,
      "realName": "杨阳洋",
      "account": "09612345678",
      "coinType": "ADA",
      "market": "FOREX_US",
      "direction": 2,
      "tradePair": "ADA/USDT",
      "pairName": "ADA/美元",
      "productName": "ADA/美元",
      "amount": 20.00,
      "profitRatio": 85.00,
      "seconds": 30,
      "openingPrice": 0.15920000,
      "closingPrice": 0.15930000,
      "openingTime": "2026-06-23 04:11:14",
      "closingTime": "2026-06-23 04:11:43",
      "balance": 7631.84000000,
      "walletBalanceAfterSettle": 7631.84000000,
      "expectedProfit": 17.00,
      "actualProfit": -20.00,
      "status": 3,
      "controlType": null,
      "controlResult": 2,
      "remark": null,
      "createTime": "2026-06-23 04:11:14",
      "updateTime": "2026-06-23 04:11:44",
      "version": 1,
      "userControl": 3,
      "globalControlStateSnapshot": "RANDOM",
      "globalControlApplied": 1,
      "hasBoughtFund": 1
    }
  ]
}
```

### 3.1.1 合约订单-操作

权限均为 `trade:contract:list`。`control_type`：`1` 必赢、`2` 必输。

#### 3.1.1.1 控单-赢

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/trade/contract/win/{id}` |
| Java 对照 | `PUT /fubang/fbcontractorders/win/{id}` |

**说明**：仅当 `control_type IS NULL` 时写入 `1`（必赢）。

#### 3.1.1.2 控单-输

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/trade/contract/lose/{id}` |
| Java 对照 | `PUT /fubang/fbcontractorders/lose/{id}` |

**说明**：仅当 `control_type IS NULL` 时写入 `2`（必输）。

#### 3.1.1.3 修改交易方向

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/trade/contract/direction/{id}/{direction}` |
| Java 对照 | `PUT /fubang/fbcontractorders/direction/{id}/{direction}` |

**路径参数**：`direction` 为 `1`（买入做多）或 `2`（卖出做空）。

#### 3.1.1.4 本页四态批量控单

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/trade/contract/control/batch-current-page/directional` |
| Java 对照 | `PUT /fubang/fbcontractorders/control/batch-current-page/directional` |

**请求体**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `pageNum` | int64 | 当前页码 |
| `pageSize` | int64 | 每页条数 |
| `keyword` | string | 与列表一致 |
| `status` | string | 与列表一致 |
| `beginTime` / `endTime` | string | 创建时间范围（与列表 `params[beginTime]`/`params[endTime]` 对应） |
| `controlState` | string | `LONG_WIN` / `LONG_LOSE` / `SHORT_WIN` / `SHORT_LOSE` |

**说明**：对当前页内 `status=1` 且 `control_type IS NULL` 的订单，按方向写入必赢/必输；不修改今日全局配置。`controlState=RANDOM` 拒绝。

**响应**：`{ "affectedCount": 3 }`；无符合条件订单时返回「当前页没有可控制的进行中订单」。

**controlState 语义**（对齐 `ContractGlobalControlState.resolveResult`）：

| 值 | 做多(direction=1) | 做空(direction=2) |
| --- | --- | --- |
| `LONG_WIN` | 必赢(1) | 必输(2) |
| `LONG_LOSE` | 必输(2) | 必赢(1) |
| `SHORT_WIN` | 必输(2) | 必赢(1) |
| `SHORT_LOSE` | 必赢(1) | 必输(2) |

#### 3.1.1.5 结算日志

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/trade/contract/detail/{id}` |
| 权限 | `trade:contract:list` |
| Java 对照 | `GET /fubang/fbcontractordersdetail/{orderId}` |

**说明**：`id` 为合约订单主键；从 `fb_crypto_contract_orders_detail` 按 `order_id` 查询，`detail` 为 `remark` 字段 JSON（对齐 Java `ContractSettlementLogDTO`）。

**响应**：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | string | 明细表主键 |
| `orderId` | string | 合约订单 id |
| `userId` | string | 用户 id |
| `detail` | string | 结算步骤 JSON 字符串 |

---

### 3.2 委托订单

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/trade/entrust/list` |
| 权限 | `trade:entrust:list` |
| API 定义 | `desc/system/api/trade/entrust.api` |
| 行实体 | `TradeEntrustItem` |

**查询参数**：`keyword`、`orderStatus`、`marketCode`

**`rows[]` 字段**：`id`、`orderNo`、`username`、`marketCode`、`stockCode`、`orderType`、`entrustPrice`、`entrustQty`、`dealQty`、`orderStatus`、`stopLossPrice`、`priceType`、`priceFloatRange`、`validity`、`fee`、`direction`、`limitPrice`、`entrustTime`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

### 3.3 成交订单

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/trade/deal/list` |
| 权限 | `trade:deal:list` |
| API 定义 | `desc/system/api/trade/deal.api` |
| 行实体 | `TradeDealItem` |

**查询参数**：`keyword`、`marketCode`、`dealType`

**`rows[]` 字段**：`id`、`dealNo`、`username`、`marketCode`、`stockCode`、`dealType`、`dealPrice`、`dealQty`、`dealAmount`、`fee`、`dealTime`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

## 四、投信管理

### 4.1 持仓订单

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/invest/position/list` |
| 权限 | `invest:position:list` |
| API 定义 | `desc/system/api/invest/position.api` |
| 行实体 | `InvestPositionItem` |
| 数据表 | `fb_fund_position`（JOIN `fb_users`；`fb_fund` 补名称/周期/收益率） |

**查询参数**

| 参数 | 说明 |
| --- | --- |
| `pageNum` / `pageSize` | 分页 |
| `keyword` | 用户名/手机号/真实姓名模糊（对齐 Java `getUserIds`） |
| `fundCode` | 基金代码 |
| `status` | `p.status`：`1` 进行中 / `0` 结束 |
| `params[beginTime]` / `params[endTime]` | `create_time` 区间 |

**`rows[]` 字段**：`id`、`userId`、`username`、`mobile`、`realName`、`fundCode`、`fundName`、`amount`、`buyDate`、`startDate`、`endDate`、`period`、`rate`、`profit`、`state`、`status`、`lastProfitDate`、`createTime`、`updateTime`

**响应示例**

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [
    {
      "id": "2067631810789584897",
      "userId": "2051881499162091522",
      "username": "13800138000",
      "mobile": null,
      "realName": "abc",
      "fundCode": "FUBON",
      "fundName": "FUBON",
      "amount": 1999,
      "buyDate": "2026-06-18",
      "startDate": "2026-06-18",
      "endDate": "2026-07-18",
      "period": 30,
      "rate": 0.45,
      "profit": 29.99,
      "state": "PENDING",
      "status": 1,
      "lastProfitDate": "2026-06-18",
      "createTime": "2026-06-18 23:33:33",
      "updateTime": "2026-06-19 00:10:02"
    }
  ]
}
```

---

### 4.1.1 收益订单

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/invest/position/order/list` |
| 权限 | `invest:position:list` |
| API 定义 | `desc/system/api/invest/position.api` |
| 行实体 | `InvestPositionOrderItem` |
| 数据表 | `fb_fund_profit_log` |

**说明**：持仓列表操作列「收益订单」抽屉调用；按 `userId` + `positionId` 查询每日收益流水。

**查询参数**

| 参数 | 必填 | 说明 |
| --- | --- | --- |
| `userId` | 是 | 用户 ID |
| `positionId` | 是 | 持仓主键 |
| `pageNum` / `pageSize` | 否 | 分页 |

**`rows[]` 字段**：`id`、`userId`、`positionId`、`orderId`、`fundCode`、`profitDate`（收益日期）、`profit`（收益金额）、`cumulativeProfit`（累计收益）、`status`（1 有效 / 0 无效）、`profitDatetime`、`createTime`、`updateTime`

**响应示例**

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [
    {
      "id": "2069815320183369729",
      "userId": "9",
      "positionId": "2066881461329932290",
      "fundCode": "FUBON",
      "profitDate": "2026-06-18",
      "profit": 150,
      "cumulativeProfit": 150,
      "status": 1,
      "profitDatetime": "2026-06-18 00:10:01",
      "createTime": "2026-06-18 00:10:01",
      "updateTime": "2026-06-18 00:10:01"
    }
  ]
}
```

---

### 4.1.2 修改收益

| 项 | 值 |
| --- | --- |
| 查询修改前 | `POST /invest/position/profit/before` |
| 提交修改 | `PUT /invest/position/profit` |
| 权限 | `invest:position:list` |
| 数据表 | `fb_fund_profit_log` |

对齐 Java `POST /fubang/fbfundposition/profitBefore`、`PUT /fubang/fbfundposition/updateProfit`。

**查询修改前请求体**

```json
{
  "id": "2066881461329932290",
  "profitDate": "2026-06-18"
}
```

**查询修改前响应**：`data.profit` 为当日 `profit_amount`；无流水时为 `null`。

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "profit": 150
  }
}
```

**提交修改请求体**

| 字段 | 说明 |
| --- | --- |
| `id` | 持仓 ID |
| `profitDate` | 收益日期 `yyyy-MM-dd` |
| `profit` | 修改后收益，必须 > 0 |

**业务规则**

- 管理端提交前须已查询到修改前收益（`profitBefore` 非空）
- 后端校验该日已有 `fb_fund_profit_log` 记录后才允许覆盖
- 修改后收益必须大于 0

---

### 4.2 投信列表

对接表 `fb_fund`（对齐 Java `FbFundController` / `FundServiceImpl`）。

#### 4.2.1 分页列表

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/invest/list/list` |
| 权限 | `invest:list:list` |
| API 定义 | `desc/system/api/invest/list.api` |
| 行实体 | `InvestListItem` |

**查询参数**：`pageNum`、`pageSize`、`keyword`（code/name 模糊）、`name`、`code`、`status`、`soldOut`、`orderField`（`sort`/`create_time`/`code`/`name`）、`order`（`asc`/`desc`）、`params[beginTime]`、`params[endTime]`

**`rows[]` 字段**：`id`、`code`、`symbol`、`name`、`company`、`ev`、`price`、`currency`、`description`、`poster`、`status`、`soldOut`、`rateMin`、`rateMax`、`rate`、`minAmount`、`minAppendAmount`、`maxAmount`、`period`、`rateMode`、`latestAmountRaised`、`lastestFundingDate`、`sort`、`createTime`、`updateTime`

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [
    {
      "id": "2057058124767494146",
      "code": "FUBON",
      "symbol": "FUBON FINANCIAL",
      "name": "FUBON",
      "company": "FUBON FINANCIAL",
      "ev": "430B",
      "price": 0,
      "currency": "USD",
      "description": "限购200万份",
      "poster": "/uploads/fund/8ff735124d854d8aa2e3c1e77fd79080_cishi.jpeg",
      "status": 1,
      "soldOut": 0,
      "rateMin": 0.14,
      "rateMax": 0.52,
      "rate": 0.45,
      "minAmount": 1000,
      "minAppendAmount": 100,
      "maxAmount": 10000,
      "period": 30,
      "rateMode": "FIXED",
      "latestAmountRaised": 0,
      "sort": 0,
      "createTime": "2026-05-20 19:17:29",
      "updateTime": "2026-05-20 19:17:29"
    }
  ]
}
```

#### 4.2.2 详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/invest/list/{id}` |
| 权限 | `invest:list:list` |

返回单条 `InvestListItem`（编辑弹窗回显）。

#### 4.2.3 新增

| 项 | 值 |
| --- | --- |
| 方法 | `POST` |
| 路径 | `/invest/list` |
| 权限 | `invest:list:list` |
| 请求体 | `InvestListSaveReq`（`id` 不传） |

#### 4.2.4 修改

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/invest/list` |
| 权限 | `invest:list:list` |
| 请求体 | `InvestListSaveReq`（`id` 必填） |

#### 4.2.5 删除

| 项 | 值 |
| --- | --- |
| 方法 | `DELETE` |
| 路径 | `/invest/list/{ids}` |
| 权限 | `invest:list:list` |

`ids` 为逗号分隔主键，支持批量。

**`InvestListSaveReq` 主要字段**：`code`、`symbol`、`name`、`company`、`rate`、`minAmount`、`maxAmount`、`period`、`sort` 必填；`minAppendAmount` 默认 100；`poster` 支持 data URL / base64（落盘为 `/uploads/fund/...`）或已有 http(s)/相对路径原样入库；`soldOut`：0 进行中 / 1 已售罄。

**海报规则**（对齐 Java `resolvePoster`）：

- 空白 → 不入库 / 修改时清空
- 已是 `http(s)://` 或 `/uploads/`、`/fund/` 相对路径 → 原样入库
- 否则按 base64 写入 `FileUpload.Path/fund/`，入库 `/uploads/fund/{uuid}_{code}.ext`
- 未配置 `FileUpload.Path` 时 base64 上传返回业务错误

---

## 五、产品管理

### 5.1 产品配置

对接表 `fb_fund_product`（对齐 Java `FbFundProductController`）。

#### 5.1.1 分页列表

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/product/config/list` |
| 权限 | `product:config:list` |
| API 定义 | `desc/system/api/product/config.api` |
| 行实体 | `ProductConfigItem` |

**查询参数**：`pageNum`、`pageSize`、`keyword`（code/name 模糊）、`type`（FOREX/STOCK/FUND 等）、`status`、`orderField`、`order`、`params[beginTime]`、`params[endTime]`

**`rows[]` 字段**：`id`、`code`、`alias`、`tradePair`、`name`、`type`、`market`、`tradingHours`、`description`、`status`、`dividendRatio`、`currency`、`period`、`totalDividendRate`、`dailyDividendRate`、`dividendEndDate`、`dividendStrDate`、`isLocked`、`limitBuyCount`、`limitSellDays`、`limitBuyAmount`、`sort`、`odds`、`createTime`、`updateTime`

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 1,
  "rows": [
    {
      "id": "110",
      "code": "EOS",
      "alias": "EOS",
      "tradePair": "EOS/USDT",
      "name": "EOS/美元",
      "type": "FOREX",
      "market": "FOREX_US",
      "tradingHours": "24H",
      "description": "USD",
      "status": 1,
      "dividendRatio": 0,
      "currency": "USD",
      "period": 1,
      "totalDividendRate": 0,
      "dailyDividendRate": 0,
      "sort": 24,
      "odds": 1,
      "createTime": "2025-03-01 14:11:52",
      "updateTime": "2026-06-07 16:53:12"
    }
  ]
}
```

#### 5.1.2 详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/product/config/{id}` |
| 权限 | `product:config:list` |

#### 5.1.3 新增

| 项 | 值 |
| --- | --- |
| 方法 | `POST` |
| 路径 | `/product/config` |
| 权限 | `product:config:list` |
| 请求体 | `ProductConfigSaveReq` |

#### 5.1.4 修改

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/product/config` |
| 权限 | `product:config:list` |
| 请求体 | `ProductConfigSaveReq`（`id` 必填；`code` 不可改） |

#### 5.1.5 删除

| 项 | 值 |
| --- | --- |
| 方法 | `DELETE` |
| 路径 | `/product/config/{ids}` |
| 权限 | `product:config:list` |

**`ProductConfigSaveReq` 主要字段**：`code`、`name`、`type`、`market`、`status`、`currency`、`odds` 必填；`alias`、`tradePair`、`tradingHours` 可选。

---

### 5.2 产品实时数据

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/product/realtime/list` |
| 权限 | `product:realtime:list` |
| API 定义 | `desc/system/api/product/realtime.api` |
| 行实体 | `ProductRealtimeItem` |

**查询参数**：`keyword`、`productCode`、`type`

**`rows[]` 字段**：`id`、`productCode`、`tradeCode`、`name`、`type`、`currentPrice`、`changeAmount`、`changePercent`、`openPrice`、`highPrice`、`lowPrice`、`volume`、`turnover`、`direction`、`tradeDate`、`updateTime`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

### 5.3 产品历史数据

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/product/history/list` |
| 权限 | `product:history:list` |
| API 定义 | `desc/system/api/product/history.api` |
| 行实体 | `ProductHistoryItem` |

**查询参数**：`keyword`、`productCode`、`market`

**`rows[]` 字段**：`id`、`productCode`、`productName`、`productType`、`market`、`tradeDate`、`openPrice`、`highPrice`、`lowPrice`、`closePrice`、`changeAmount`、`changePercent`、`volume`、`turnover`、`updateTime`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

## 六、通知管理

### 6.1 市场新闻

对接表 `fb_market_news`（对齐 Java `FbMarketNewsController`）。

#### 6.1.1 分页列表

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/notify/news/list` |
| 权限 | `notify:news:list` |
| API 定义 | `desc/system/api/notify/news.api` |
| 行实体 | `NotifyNewsItem` |

**查询参数**：`pageNum`、`pageSize`、`keyword`（title/summary 模糊）、`source`、`category`、`orderField`、`order`、`params[beginTime]`、`params[endTime]`

**默认排序**：`COALESCE(publish_time, created_at) DESC`（对齐 Java `getWrapper`）

**`rows[]` 字段**：`id`、`title`、`summary`、`content`、`source`、`category`、`url`、`imageUrl`、`viewCount`、`publishTime`、`createdAt`、`updatedAt`

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": [
    {
      "id": "2069145305225207810",
      "title": "金属期市：美伊达成协议的希望提振工业金属价格",
      "summary": null,
      "content": null,
      "source": "Reuters",
      "category": "LME:AH1!,COMEX:ZNC1!,MCX:LEAD1!,MYX:FTIN1!,MCX:NICKEL1!,TVC:GOLD,BIST:XAGUSD1!,NYMEX:PL1!,BIST:XPDUSD1!,LME:CA1!",
      "url": "https://cn.tradingview.com/news/reuters.com,2026:newsml_L6S42U0XW:0/",
      "imageUrl": null,
      "viewCount": 0,
      "publishTime": "2026-06-23 00:11:07",
      "createdAt": "2026-06-23 03:47:38",
      "updatedAt": "2026-06-23 03:47:38"
    }
  ]
}
```

#### 6.1.2 详情

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/notify/news/{id}` |
| 权限 | `notify:news:list` |

#### 6.1.3 新增

| 项 | 值 |
| --- | --- |
| 方法 | `POST` |
| 路径 | `/notify/news` |
| 权限 | `notify:news:list` |
| 请求体 | `NotifyNewsSaveReq` |

#### 6.1.4 修改

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/notify/news` |
| 权限 | `notify:news:list` |
| 请求体 | `NotifyNewsSaveReq`（`id` 必填） |

**`NotifyNewsSaveReq` 主要字段**：`title` 必填；`summary`、`content`、`source`、`category`、`url`、`imageUrl`、`viewCount`、`publishTime` 可选。

---

### 6.2 通知发布

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/notify/publish/list` |
| 权限 | `notify:publish:list` |
| API 定义 | `desc/system/api/notify/publish.api` |
| 行实体 | `NotifyPublishItem` |

**查询参数**：`keyword`、`notifyType`、`readStatus`

**`rows[]` 字段**：`id`、`receiveUserId`、`title`、`content`、`notifyType`、`readStatus`、`deleted`、`sendTime`、`expireTime`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

## 七、K线管理

### 7.1 K线管理

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/kline/main/list` |
| 权限 | `kline:main:list` |
| API 定义 | `desc/system/api/kline/main.api` |
| 行实体 | `KlineMainItem` |

**查询参数**：`keyword`、`productCode`、`symbol`

**`rows[]` 字段**：`id`、`productCode`、`symbol`、`redisKey`、`barCount`、`latestTime`、`open`、`high`、`low`、`close`、`volume`

**响应示例**（待补充）：

```json
{
  "code": 200,
  "msg": "操作成功",
  "total": 0,
  "rows": []
}
```

---

## 八、App 管理

### 8.1 App 品牌资源

对接表 `app_branding_config`（对齐 Java `AppBrandingConfigController`）。

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/app/brand/active` |
| 权限 | `appBrand:main:list` |
| API 定义 | `desc/system/api/app/brand.api` |

**响应字段**：`id`、`revision`、`splashUrl`、`splashEnabled`、`homeBannerUrl`、`homeBannerEnabled`、`profilePosterUrl`、`profilePosterEnabled`、`updatedAt`、`updatedBy`

#### 8.1.1 保存

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/app/brand` |
| 请求体 | `AppBrandingSaveReq` |

保存时自动 bump `revision`（`yyyyMMddHHmmss`），响应返回最新 `AppBrandingItem`（含新 revision）；启用远程图时对应 URL 必填。

#### 8.1.2 品牌图片上传

| 项 | 值 |
| --- | --- |
| 方法 | `POST` |
| 路径 | `/app/brand/upload/image?kind=splash\|home_banner\|profile_poster` |
| 类型 | `multipart/form-data`，字段 `file` |

**响应**：`{ url, src }`，入库路径形如 `/uploads/branding/...`

---

### 8.2 App 版本管理

对接表 `app_release_versions`（对齐 Java `AppReleaseVersionController`）。

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/app/version/active` |
| 权限 | `appVersion:main:list` |
| API 定义 | `desc/system/api/app/version.api` |

**响应字段**：`id`、`version`、`description`、`downloadUrl`、`apkFileUrl`、`iosUrl`、`ipaFileUrl`、`isForce`、`isHotUpdate`、`updatedAt`

#### 8.2.1 保存

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/app/version` |
| 请求体 | `AppReleaseVersionSaveReq` |

`version`、`description`、`downloadUrl` 必填。

---

### 8.3 App 安装包上传

对齐 Java `AppReleaseUploadController`；配置项 `AppReleaseUpload`（`wwwrootBase`、`subPath`、`defaultDomain`、`allowedDomains`）。

#### 8.3.1 上传选项

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/app/release/upload/options` |
| 权限 | `appVersion:main:list` |

**响应**：`defaultDomain`、`allowedDomains`、`urlPattern`、`wwwrootBase`

#### 8.3.2 上传安装包

| 项 | 值 |
| --- | --- |
| 方法 | `PUT` |
| 路径 | `/app/release/upload` |
| 类型 | `multipart/form-data`：`file`、可选 `domain`、`fileName` |

落盘 `{wwwrootBase}/{domain}/download/{fileName}`，对外 URL `https://{domain}/download/{fileName}`。APK 上传成功后回写 `apkFileUrl`、`downloadUrl` 及版本号；IPA 仅回写 `ipaFileUrl`。

---

## 九、仪表盘 / 分析页

对齐 Java `GET /fubang/dashboard/statistics`（`DashboardController.getStatistics`）。

### 9.1 分析页概览统计

| 项 | 值 |
| --- | --- |
| 方法 | `GET` |
| 路径 | `/dashboard/statistics` |
| API 定义 | `desc/system/api/dashboard/dashboard.api` |
| Java 对照 | `GET /fubang/dashboard/statistics` |

**查询参数**：

| 参数 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- |
| `type` | int | `1` | `0` 当天；`1` 本周（周一至今天）；`2` 本月（1 号至今）；非法回退 `1` |

**统计口径**：各业务表 `created_at` 落在时间范围内。

| 字段 | 说明 |
| --- | --- |
| `pendingUserCount` / `approvedUserCount` / `verifiedUserCount` / `rejectedUserCount` | `fb_identity_verify` 按 `status` 计数 |
| `pendingUserWalletCount` / `approvedUserWalletCount` / `rejectedUserWalletCount` | `fb_account_application` 按 `status` 对 `user_id` 去重计数 |
| `depositCount` | `fb_deposits` 中 `status=PENDING` 条数 |
| `depositSum` | `status=SUCCESS` 且 `payment_status=SUCCESS` 金额之和（四舍五入取整） |
| `withdrawCount` | `fb_withdraws` 中 `status=PENDING` 条数 |
| `withdrawSum` | 同充值成功金额口径 |
| `type` | 回显请求的时间维度 |

**响应示例**：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "type": 0,
    "pendingUserCount": 0,
    "approvedUserCount": 0,
    "verifiedUserCount": 4,
    "rejectedUserCount": 0,
    "pendingUserWalletCount": 0,
    "approvedUserWalletCount": 5,
    "rejectedUserWalletCount": 0,
    "depositCount": 0,
    "depositSum": 4000,
    "withdrawCount": 0,
    "withdrawSum": 4600
  }
}
```

---

## 相关文档

- [本地开发说明](./local-dev.md)
- [API 定义目录](../desc/system/api/)
