# 变更日志

本文件记录 Ovra-Zero 及仓库内配套前端/脚本的**功能性与配置类**变更。  
格式约定见 [.cursor/rules/code-comments-changelog.mdc](.cursor/rules/code-comments-changelog.mdc)。

## [未发布]

### 变更
- **文档**：全面对齐总控单体化架构，移除 etcd/auth 独立进程说明（`README.md`、`docs/local-dev.md`、`deploy/k3d/docs/`、`INSTALL_REDIS.md`）
- **总控单体化**：auth 路由合并进 system，登录逻辑进程内直调 `sysrpclogic`，移除 etcd 与 auth 独立进程（`desc/system/api/auth/`、`app/system/internal/logic/auth/`、`etc/dev/`、`deploy/helm/ovra-zero/`）
- **系统用户**：`sys_user` / `sys_logininfor` / `sys_social` 的 `user_name` 列统一重命名为 `username`；登录日志、在线用户、社会化绑定及交易委托/成交等相关接口 JSON 统一为 `username`（`base.api`、`monitor/*.api`、`trade/*.api`、前端 monitor/social/trade）
- **租户**：`sys_tenant.contact_user_name` 列重命名为 `contact_username`；租户接口请求/响应 JSON 统一为 `contactUsername`（`base.api`、`tenant.api`）

### 新增
- **新手指引**：[`docs/newbie-guide.md`](docs/newbie-guide.md) 从前端点击到 MySQL/Redis 的完整链路、登录流程、改接口步骤与第一天学习路径
- **实名认证审核**：`PUT /member/kyc/verify` 通过/拒绝待审记录并同步 `fb_users`；前端审核弹窗（证件照+拒绝原因），全量页保留详情、分析页快捷列表仅「审核」（`kyc.api`、`fb_member.go`、`kyc-audit-modal.vue`、`shortcut-kyc-table.vue`）
- **钱包申请审核**：`PUT /fund/walletApply/verify` 通过时按账户类型开通默认币种钱包；前端审核弹窗（通过/拒绝+审核意见），全量页保留详情/流水/登录、分析页快捷列表仅「审核」（`wallet_apply.api`、`fb_wallet_apply.go`、`wallet-apply-audit-modal.vue`、`shortcut-wallet-table.vue`）
- **分析页快捷列表**：四卡下方纵向堆叠实名认证/钱包申请/充值/提现精简表格，时间维度与顶部今日/本周/本月联动，操作复用各业务页（`dashboard/analytics/analytics-shortcut-lists.vue`、`shortcut-*-table.vue`）
- **分析页仪表盘统计**：`GET /dashboard/statistics?type=0|1|2` 对接实名/钱包/充值/提现四卡数据，对齐 Java `DashboardController.getStatistics`（`dashboard.api`、`fb_dashboard_stats.go`、`analytics/index.vue`、`biz-api.md` 九）
- **App 品牌资源 / App 版本管理**：`GET /app/brand/active`、`PUT /app/brand`、品牌图上传；`GET /app/version/active`、`PUT /app/version`；`GET /app/release/upload/options`、`PUT /app/release/upload` 对接 `app_branding_config`、`app_release_versions`（`app/*.api`、`app_config.go`、`appBrand/main`、`appVersion/main`、`biz-api.md` 八）
- **市场新闻 6.1**：`GET /notify/news/list` 对接 `fb_market_news`；新增详情/增改；前端列表、新增/编辑弹窗（`news.api`、`fb_market_news.go`、`notify-news-modal.vue`、`biz-api.md` 6.1）
- **产品配置 5.1**：`GET /product/config/list` 对接 `fb_fund_product`；新增详情/增删改；前端列表与编辑弹窗（`config.api`、`fb_fund_product.go`、`product-config-modal.vue`、`biz-api.md` 5.1）
- **投信列表 4.2**：`GET /invest/list/list` 对接 `fb_fund`；新增详情/增删改与海报 base64 落盘；前端列表、编辑弹窗与海报上传（`list.api`、`fb_fund.go`、`invest-fund-modal.vue`、`biz-api.md` 4.2）
- **投信持仓修改收益**：`POST /invest/position/profit/before` 查询修改前收益；`PUT /invest/position/profit` 覆盖 `fb_fund_profit_log`；操作列「修改收益」弹窗（`position.api`、`fb_fund_position.go`、`position-update-profit-modal.vue`、`biz-api.md` 4.1.2）
- **投信持仓 4.1 / 4.1.1**：`GET /invest/position/list` 对接 `fb_fund_position`；`GET /invest/position/order/list` 收益订单抽屉（`position.api`、`fb_fund_position.go`、`position-profit-order-drawer.vue`、`biz-api.md` 4.1～4.1.1）
- **合约订单结算日志**：`GET /trade/contract/detail/{id}` 对接 `fb_crypto_contract_orders_detail`；已结算行操作列「日志」弹窗展示结算步骤（`contract.api`、`fb_contract_order.go`、`contract-settlement-log-modal.vue`、`biz-api.md` 3.1.1.5）

### 变更
- **分析页四卡图标**：改用 Iconify `mdi:account-check` / `mdi:wallet` / `mdi:cash-plus` / `mdi:cash-minus`（`dashboard/analytics/index.vue`）
- **实名/钱包审核接口**：契约对齐 Java `PUT /verify`，请求体改用 `state`（实名 `VERIFIED`/`REJECTED`，钱包 `APPROVED`/`REJECTED`）；钱包通过时补建 `main/USD` 并按账户类型默认币种开钱包，审核意见至少 5 字（`kyc.api`、`wallet_apply.api`、`fb_wallet_apply.go`、前端审核弹窗）
- **分析页概览卡片**：充值成功金额 `$ 0.00` 绿色加粗；提现成功金额 `-$ 4,600` 红色加粗（`analysis-overview.vue`、`dashboard/analytics/index.vue`）
- **分析页概览卡片**：`AnalysisOverview` 支持 `compact`，分析页四卡内边距与字号缩小（约默认高度 3/4）（`analysis-overview.vue`、`dashboard/analytics/index.vue`）
- **分析页工具栏**：今日/本周/本月切换改为 `size="small"`，与「在线用户」Tag 视觉对齐（`dashboard/analytics/index.vue`）
- **分析页时间维度**：今日/本周/本月切换默认选中「今日」（`type=0`）；右侧增加「在线用户」Tag，复用 `GET /member/user/stats` 的 `totalOnlineUsers`（`dashboard/analytics/index.vue`）
- **App 品牌/版本页**：Card 标题栏右侧增加「刷新」按钮（与底部刷新行为一致）（`appBrand/main/index.vue`、`appVersion/main/index.vue`）
- **App 版本管理页**：进入页与「刷新」并行请求 `/app/release/upload/options`、`/app/version/active`；发布域名下拉绑定 `allowedDomains`；表单右对齐布局对齐参考图（`appVersion/main/index.vue`）

### 维护
- **投信持仓模块**：为 `fb_fund_position.go`、position logic 与前端弹窗/抽屉补全步骤级注释（对齐 `.cursor/rules/code-comments-changelog.mdc`）
- **前端开发**：Vite `allowedHosts` 放行 ngrok 域名，支持隧道访问本地 dev（`apps/web-antd/vite.config.ts`）
- **biz-api.md**：补齐团队管理 1.6.1～1.6.4（详情/下级团队/更换上级/代理层级）请求响应与错误文案；总览表增加报表流水；团队列表补注册时间筛选参数

### 修复
- **分析页提现成功金额**：`totalValue` 为 0 时格式化为 `-$ 0.00`，与充值申请一致（`dashboard/analytics/index.vue`）
- **实名认证审核弹窗**：审核结果并入 Descriptions 表格（与用户ID/姓名/身份证号同表），通过/拒绝单行、拒绝原因在下方，对齐参考图（`kyc-audit-modal.vue`）
- **分析页快捷列表无数据**：去掉与「今日/本周/本月」叠加的时间筛选（待办常跨日），挂载后主动 `query` 加载（`use-analytics-shortcut-grid.ts`、`shortcut-*-table.vue`）
- **App 版本/品牌页控件不渲染**：`a-input`/`a-select`/`a-switch` 等未从 `antdv-next` 导入（项目仅全局注册 Button），改为显式 `import` 并使用 `Input`/`Select`/`Switch` 等组件（`appVersion/main/index.vue`、`appBrand/main/index.vue`）
- **App 品牌页表单布局**：标签列固定 140px 右对齐，对齐 Java `label-width`（`appBrand/main/index.vue`）
- **App 品牌保存响应**：`PUT /app/brand` 返回含 bump 后 `revision` 的 `AppBrandingItem`；查询 `revision` 空值兜底为 `0`（`brand.api`、`save_logic.go`、`appBrand/main/index.vue`）
- **App 管理菜单路由冲突**：`App品牌资源` / `App版本管理` 子菜单 path 均为 `main`，前端均解析为 `/app/main` 导致两页相同；改为 `brand` / `version`（`bin/sql/ovra_zero-2.1.sql`、`bin/sql/patch-app-menu-path.sql`）
- **Traefik 网关 `/app` 路由**：`router-system` 增加 `PathPrefix(/app)`，修复经 `localhost:5666/api/app/*` 访问 App 品牌/版本接口 404（`bin/traefik/dynamic.yaml`）
- **Traefik 网关 `/dashboard` 路由**：`router-system` 增加 `PathPrefix(/dashboard)`，修复分析页统计接口经网关 404（`bin/traefik/dynamic.yaml`）
- **投信列表/产品配置写操作响应**：新增/编辑/删除改 `OkJsonCtx` 返回 `{code,msg}`，修复 `httpx.Ok` 无 body 导致 `postWithMsg` 判定失败、无成功提示且弹窗不关闭（`invest/list/*_handler.go`、`product/config/*_handler.go`）
- **更换上级**：仅更新 `parent_id`，不再走 `UpdateUser` 误触「用户名不能为空」；上级用户名前后端必填（`fb_team.go`、`team-change-parent-modal.vue`）
- **团队管理弹窗刷新**：关闭代理层级/更换上级弹窗后 `reload` 携带查询区当前筛选（`keyword` 等），不再空参 `query()`（`views/member/team/index.vue`）
- **团队管理写操作响应**：`PUT /member/team/changeParent`、`PUT /member/team/agentLevel` 改 `OkJsonCtx` 返回 `data`（`{userId,parentId}` / `{userId,agentLevel}`），修复 `httpx.Ok` 无 body 导致弹窗提交后不关闭（`team/*_handler.go`、`*-modal.vue`）

### 变更
- **市场新闻弹窗**：新闻来源改下拉（金色财经/Reuters/Gelonghui，默认金色财经）；新闻分类改下拉（币圈/期货/股票，默认币圈）（`notify-news-form-data.ts`、`notify-news-modal.vue`）
- **投信收益订单抽屉**：改按 `userId` + `positionId` 查询 `fb_fund_profit_log`，替换原 `fb_fund_order` 数据源（`fb_fund_position.go`、`position-profit-order-drawer.vue`、`biz-api.md` 4.1.1）
- **合约订单列表**：订单控单列 `controlType` 为 0/空显示「未控单」，3 显示「自然」（`views/biz/trade/contract/data.tsx`）
- **合约订单列表**：实际收益列正数绿色、负数红色、零为默认色（`views/biz/trade/contract/data.tsx`）
- **合约订单结算日志弹窗**：改用语义化分组 `Descriptions` 展示，对齐本项目详情弹窗样式（`contract-settlement-log-modal.vue`）
- **合约订单操作**：赢/输/改方向/本页批量控单接口改用 `putWithMsg`，成功提示操作结果，失败沿用全局错误提示（`api/biz/trade/contract/index.ts`）
- **表格操作列**：`ActionButton` / `TableActionSpace` 统一收紧按钮间距（水平内边距与项间距均为 4px）（`components/global/button.ts`、`table-action-space.vue`）
- **合约订单操作 UI**：本页批量控单 Popconfirm 文案支持折行；交易方向改为弹窗单选「买入做多/卖出做空」；操作列拆分赢/输与交易方向显示条件（持仓中且未控单才显示赢/输，持仓中即可改方向）（`contract-direction-modal.vue`、`data.tsx`、`index.vue`）
- **合约订单筛选**：控单结果增加「自然」(3)，后端按 `control_type` 空/3 筛选；导出按钮移至查询按钮后（`fb_contract_order.go`、`views/biz/trade/contract/`）
- **合约订单 3.1.1**：新增赢/输/改方向与本页四态批量控单接口；前端操作列与本页批量按钮 Popconfirm（`contract.api`、`fb_contract_order.go`、`views/biz/trade/contract/`、`biz-api.md` 3.1.1）
- **合约订单 3.1**：`GET /trade/contract/list` 对接 `fb_crypto_contract_orders`（对齐 Java `getPageData`/`getRecords`）；前端列表字段与筛选改 `status`/`controlResult`（`contract.api`、`fb_contract_order.go`、`views/biz/trade/contract/`、`biz-api.md` 3.1）
- **充值管理 2.4**：`GET /fund/recharge/list` 对接 `fb_deposits`（对齐 Java `selectPageWithUser`）；批准先入账款再改订单 SUCCESS，拒绝置 CANCELLED；前端批准 Popconfirm + 拒绝理由弹窗（`recharge.api`、`fb_deposit.go`、`views/biz/fund/recharge/`、`biz-api.md` 2.4～2.4.2）
- **提现管理 2.3**：`GET /fund/withdraw/list` 对接 `fb_withdraws`（对齐 Java `selectPageWithUser`）；新增批准/拒绝接口与前端 Popconfirm、拒绝理由弹窗（`withdraw.api`、`fb_withdraw.go`、`views/biz/fund/withdraw/`、`biz-api.md` 2.3～2.3.2）
- **账户流水 2.2**：`GET /fund/statement/list` 对接 `fb_account_flow_records`（对齐 Java `selectPageWithUser`）；新增 `GET /detail/{id}` 与详情弹窗（`statement.api`、`fb_report.go`、`views/biz/fund/statement/`、`biz-api.md` 2.2～2.2.1）
- **钱包申请对齐 Java**：列表 `selectPageWithUser`（`created_at` 时间、`state`/`verified`/`userId` 等筛选）；流水改 `GET /flow/currentMonth?userId=` 当月全量；登录记录对齐 `selectPageWithUser`；前端详情弹窗与流水/登录抽屉（`wallet_apply.api`、`fb_wallet_apply.go`、`views/biz/fund/walletApply/`、`biz-api.md` 2.1～2.1.3）
- **团队统计**：`GET /member/team/stats` 对齐 Java `getTeamStatsAll`（keyword 定位根用户、parent_id 树计数、agent_level 截断与下级余额汇总）；stats 仅 keyword（`fb_team.go`、`stats_logic.go`、`biz-api.md` 1.7）
- **更换上级弹窗**：展示只读上级 ID + 可编辑上级用户名；`PUT /member/team/changeParent` 改按 `username` 查上级（对齐 Java `changeAgent`）（`team-change-parent-modal.vue`、`fb_team.go`）
- **团队管理代理层级**：`PUT /member/team/agentLevel` 对齐 Java `FbUsersServiceImpl.updateAgentLevel`（校验文案、`updated_at`）；下级团队列表深度随 `agent_level` 限制（`fb_team.go`）
- **团队管理代理层级弹窗**：代理层级 label 左对齐，Radio 选项单行展示（`team-agent-level-modal.vue`）
- **团队管理代理卡片**：顶部统计卡片数值字号由 `text-2xl` 改为 `text-xl`（`ruoyi-plus-vben5/apps/web-antd/src/views/member/team/team-stats.vue`）
- **用户报表流水抽屉**：`GET /member/report/flow/{userId}` 查询对齐 Java `selectPageWithUser`；抽屉 9 列与「{姓名}的流水记录」标题（`fb_report.go`、`report-flow-drawer.vue`）
- **用户报表列表**：`GET /member/report/list` 两阶段对齐 Java `getPageData`（批量聚合余额/充提/盈亏/团队/登录 IP）（`fb_report.go`、`report.api`）
- **表格用户名列复制**：抽取 `renderCopyableValue`/`copyText` 公共工具，所有含「用户名」列的 member/biz 列表均支持一键复制（`utils/render-copyable.tsx`、`views/**/data.tsx`）
- **实名认证列表查询**：`GET /member/kyc/list` 对齐 Java `selectPageWithUser`（JOIN 字段、keyword/idCardNo/BETWEEN 时间等）（`fb_member.go`、`kyc.api`）
- **操作列按钮间距**：新增全局 `TableActionSpace`（2px），替换各页 `#action` 内默认 8px `Space`（`components/global/table-action-space.vue`、各 `views/**/index.vue`）
- **业务用户编辑判重**：`PUT /member/user` 在用户名或身份证号变更时查询去重，冲突返回「用户名已经存在」「身份证号已经存在」（`fb_member.go`）
- **业务用户编辑头像**：编辑抽屉支持裁剪上传头像（参考系统用户 Avatar + 个人中心 CropperAvatar）；`PUT /member/user` 增加 `avatar` 字段（`user-edit-drawer.vue`、`member/user.api`、`fb_member.go`）
- **用户详情接口**：`GET /member/user/{id}` 响应改为独立实体 `MemberUserInfoResp`，补全 fb_users 字段、上级摘要、钱包/投信聚合与 Redis 在线状态（`member/user.api`、`fb_member.go`、`info_logic.go`）
- **业务用户编辑表单**：改为右侧抽屉双列布局，字段对齐管理端（密码/密保/佣金/实名/合约控制等）（`member/user.api`、`user-edit-drawer.vue`）

### 新增
- **团队管理操作**：详情弹窗、下级团队抽屉、更换上级与代理层级；后端 `GET /member/team/{id}`、`GET /members/{userId}`、`PUT /changeParent`、`PUT /agentLevel`（`fb_team.go`、`views/member/team/`）
- **钱包删除**：`DELETE /member/wallet/{ids}` 按主键物理删除 `fb_user_wallets`；钱包管理操作列改为仅「删除」（`wallet.api`、`fb_user_wallet.go`、`views/member/wallet/index.vue`）
- **实名认证详情弹窗**：列表「详情」左侧 Descriptions、右侧身份证正反面预览（`ruoyi-plus-vben5/apps/web-antd/src/views/member/kyc/kyc-detail-modal.vue`）
- **已删用户抽屉**：列表「已删用户」打开抽屉展示 `deleted=1` 列表，操作列「恢复」调用 `PUT /member/user/restore/{ids}`（`deleted-users-drawer.vue`、`restore_logic.go`）
- **业务用户编辑**：`GET /member/user/{id}` 详情与 `PUT /member/user` 保存；列表编辑按 id 拉取并提交（`member/user.api`、`fb_member.go`、`views/member/list/`）
- **业务用户删除/重置密码**：`DELETE /member/user/{ids}` 逻辑删、`PUT /member/user/resetPwd` MD5 更新密码（`member/user.api`、`fb_member.go`、`views/member/list/`）
- **钱包加减款接口**：新增 `PUT /member/wallet/addOrSubtract`，按 Java `addOrSubtract` 实现加款/减款、流水写入与 flowType 校验（`desc/system/api/member/wallet.api`、`dal/fb_user_wallet.go`、`logic/member/wallet/add_or_subtract_logic.go`）
- **用户管理接口对接 fb_* 表**：9 个 member 列表/统计/流水接口接入真实查询；新增 `FbMemberDal` 封装多表 JOIN 与聚合（`app/system/internal/dal/fb_member.go`、`app/system/internal/logic/member/`）
- **报表流水**：新增 `GET /member/report/flow/{userId}` 及前端抽屉展示（`desc/system/api/member/report.api`、`views/member/report/report-flow-drawer.vue`）
- **gentool fb_* 表**：`gen/system/gen.yaml` 增加 8 张业务表代码生成（`app/system/internal/dal/model/fb_*.gen.go`）

### 变更
- **用户列表/活跃统计对齐 Java**：USD 钱包余额、profit_log 投信分红、keyword 精确匹配；`onlineStatus` 与 stats 三项改 Redis 全局（`fb_user_redis.go`、`fb_member.go`、`member/user/*_logic.go`）
- **用户列表表格增强**：真实姓名/邀请码/ID 可复制；余额点开钱包抽屉；投信持仓分红着色；ACTIVE 显示正常（`views/member/list/`）
- **用户钱包抽屉列对齐 Java**：余额抽屉改为钱包类型/可用余额/冻结金额/券数量/货币；操作列合并为 ±款、开/关账户、冻/解金额、±抽奖券、划转五组按钮；加减款弹窗支持按加款/减款切换 flowType，并按 `id/type/amount/remark/flowType` 对接 `addOrSubtract`（`views/member/list/user-wallet-drawer.vue`、`wallet-action-modal.vue`、`api/member/wallet/index.ts`）
- **前端 Vite 代理**：统一 `/api` → Traefik `28080`；网关补全 `/member` 等业务 PathPrefix（`vite.config.ts`、`bin/traefik/dynamic.yaml`）
- **用户管理契约对齐**：`docs/biz-api.md` 1.1～1.8 字段表与响应 JSON 一致；前端 `api/member`、`views/member` 列字段改为 `username`、`createdAt`、`level1Members` 等（`ruoyi-plus-vben5/apps/web-antd/src/api/member/`、`views/member/`）

### 维护
- **注释规范**：步骤说明写在对应代码行旁，函数外保留一行或多行总结；更新 `.cursor/rules/code-comments-changelog.mdc` 示例（`member/user/*_logic.go`、`fb_user_redis.go`、`views/member/list/index.vue`）
- **用户管理 API 类型注释**：在 `desc/system/api/member/*.api` 补充类型/字段说明，`make api-system` 同步至 `types.go`；新增 `types/member_doc.go` 说明生成约定（勿手改 types.go）

### 文档
- **1.2 活跃统计**：`docs/biz-api.md` 修正 `MemberUserStatsResp` 示例数值类型为 int64
- **命名约定**：`docs/biz-api.md` 增加 API 命名约定章节
- **接口代码跟读指南**：新增 `docs/read-api-flow.md`（onboarding：契约 → 路由 → Handler → Logic → DAL，以 `/member/user/list` 为例）；`local-dev.md`、`biz-api.md` 增加交叉链接
- **业务 API 文档**：汇总用户管理～K线管理 22 个列表/统计接口，每接口预留响应 JSON 占位（`docs/biz-api.md`）

### 新增
- **用户列表活跃 Tag**：标题「用户列表」后展示 `活跃用户:{totalActiveSessions}`，新增 `GET /member/user/stats`（`views/member/list/index.vue`、`desc/system/api/member/user.api`）

- **业务用户列表页**：参考系统用户管理实现筛选+分页表格（无部门树），含占位列表 API（`ruoyi-plus-vben5/apps/web-antd/src/views/member/list/`、`desc/system/api/member/user.api`）
- **业务菜单批量占位**：新增资金管理/订单/投信/产品/通知/K线/客服/App 等 9 个一级目录及 18 个子页占位（`bin/sql/patch_biz_menus.sql`、`ruoyi-plus-vben5/apps/web-antd/src/views/biz/`）
- **业务用户管理菜单**：新增一级「用户管理」及 6 个子菜单占位页，与系统管理下后台账号管理并存（`bin/sql/patch_member_menu.sql`、`ruoyi-plus-vben5/apps/web-antd/src/views/member/`）
- **开发参考菜单**：`sys_menu` 新增「开发参考」目录，挂载 `演示使用自行删除` 下全部演示页；补 SSE/加解密演示 API（`bin/sql/patch_dev_reference_menu.sql`、`desc/system/api/dev/`、`app/system/internal/logic/dev/`）

### 变更
- **业务子页列表**：订单/投信/产品/通知/K线等 11 个模块实现筛选+分页表格（`ruoyi-plus-vben5/apps/web-antd/src/views/biz/`、`desc/system/api/trade/` 等）
- **资金管理子页**：钱包申请/账户流水/提现/充值管理实现筛选+分页表格，含占位列表 API（`ruoyi-plus-vben5/apps/web-antd/src/views/biz/fund/`、`desc/system/api/fund/`）
- **业务用户管理子页**：钱包管理/用户报表/团队管理/登录记录参考用户列表实现筛选+分页表格（`ruoyi-plus-vben5/apps/web-antd/src/views/member/`、`desc/system/api/member/`）
- **团队管理统计**：代理统计改为一行圆角卡片，亮/暗主题分别配色且背景透明度 0.8（`ruoyi-plus-vben5/apps/web-antd/src/views/member/team/team-stats.vue`）
- **业务实名认证**：参考用户列表实现筛选+分页表格，含占位列表 API（`ruoyi-plus-vben5/apps/web-antd/src/views/member/kyc/`、`desc/system/api/member/kyc.api`）
- **业务用户列表**：查询区改为单行 inline 布局（关键词/认证状态/日期 + 查询/导出/已删用户）（`ruoyi-plus-vben5/apps/web-antd/src/views/member/list/`）
- **开发规范**：新增 Cursor 规则，要求代码步骤级注释、更新本变更日志、Git 提交优先中文（`.cursor/rules/code-comments-changelog.mdc`）
- **前端动画**：页面切换默认改为 `fade` 淡入淡出，并在 `preferences.ts` 补充动画配置说明注释（`ruoyi-plus-vben5/apps/web-antd/src/preferences.ts`）

### 修复
- **钱包加减款 Unknown column UpdateBy**：AuditPlugin 更新回调改为仅当表模型含 `UpdateBy`/`UpdateTime` 字段时才写入（`toolkit/gorm/plugin/audit_plugin.go`）
- **钱包加减款响应**：`addOrSubtract` 改 `OkJsonCtx` 返回 `{code,msg}`，修复前端无法关弹窗（`handler/member/wallet/add_or_subtract_handler.go`）`GET /member/wallet/list` 补充 `userId` 并按 `w.user_id` 精确筛选；`PageWallets` SQL 对齐 Java `selectPageWithUser`（keyword 仅 username/mobile/realName、BETWEEN 时间、status/verified 等）（`dal/fb_member.go`、`wallet.api`）
- **登录过期**：认证中间件改返回 `{code:401}` JSON，修复仅弹提示不跳转登录页（`toolkit/middlewares/auth_middleware.go`、`ruoyi-plus-vben5/apps/web-antd/src/utils/http/checkStatus.ts`）
- **部门管理**：新增/编辑接口兼容 `parentId` 数值类型入参，统一转字符串后再反序列化，修复编辑时报 `type mismatch for field "parentId"`（`app/system/internal/handler/system/dept/add_handler.go`、`app/system/internal/handler/system/dept/update_handler.go`）
- **通知公告**：新增时生成 `notice_id` 雪花主键，修复 Duplicate entry '' for key PRIMARY（`app/system/internal/logic/system/notice/add_logic.go`）
- **通知公告**：列表从嵌入 `SysNotice` 正确映射 `noticeId`，修复编辑请求 `row_xx`、删除假成功（`app/system/internal/logic/system/notice/page_set_logic.go`、`app/system/internal/dal/sys_notice.go`）
- **通知公告**：详情接口将 `notice_content` 转为字符串返回（`app/system/internal/logic/system/notice/info_logic.go`）
- **租户管理**：详情/删除/改状态按主键 `id` 查询，修复列表点编辑报「数据不存在」（`app/system/internal/dal/sys_tenant.go`）
- **租户管理**：编辑时 `username`/`password` 改为可选，仅新增租户时校验必填（`desc/system/api/system/tenant.api`、`app/system/internal/types/types.go`、`app/system/internal/logic/system/tenant/add_logic.go`）

### 文档
- **本地开发**：补充 RSA 密钥格式、SSE 404、前端代理等说明（`docs/local-dev.md`）
