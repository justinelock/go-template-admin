# 本地开发：配置与启动说明

本文档说明如何在本地启动 Ovra-Zero 后端，包括依赖准备、配置修改、服务启动与验证。

## 架构与启动顺序

```text
MySQL + Redis → system (:8086，含 /auth 与总控 API) → [Traefik :28080] → 前端
```

- **无需 etcd**，**无需**单独启动 auth 进程。
- 前端开发时 Traefik 必启（Vite 代理 `/api` → `28080`）；仅 curl 测后端可直连 `8086`。

## 环境要求

| 组件 | 版本要求 | 用途 |
| --- | --- | --- |
| Go | 1.24+（项目 `go.mod` 当前为 1.25.1） | 编译与运行服务 |
| MySQL | 8.0+ | 主数据库 |
| Redis | 7+ | 缓存、会话、幂等控制 |
| Traefik | 可选 | 本地 API 网关，统一入口 |

## 配置文件

开发环境配置位于 `etc/dev/`：

```text
etc/dev/common.yaml   # 公共配置（数据库、Redis、JWT、加解密等）
etc/dev/system.yaml   # system 服务（HTTP 8086，含 /auth 登录与总控 API）
etc/dev/demo.yaml     # demo 服务（HTTP 8099）
```

各模块 yaml 会与同目录下的 `common.yaml` **自动合并**，模块内的配置项会覆盖公共配置。

服务默认通过环境变量 `ENV` 选择配置目录，未设置时默认为 `dev`：

```text
etc/{ENV}/system.yaml
etc/{ENV}/demo.yaml
```

## 服务端口

| 模块 | REST 端口 | Prometheus |
| --- | --- | --- |
| system | 8086（含 `/auth/*`） | 4002 |
| demo | 8099 | 4009 |

Traefik 网关（前端 `/api` 代理目标）：`http://127.0.0.1:28080`

> 第一次接触项目？建议先读 [newbie-guide.md](./newbie-guide.md) 了解完整链路与心智模型。

## 一、初始化项目

```sh
git clone https://github.com/cls-cloud/ovra-zero.git
cd ovra-zero
make init
```

## 二、准备基础设施

### MySQL

1. 创建数据库并导入初始化 SQL：

```sh
mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS ovra_zero DEFAULT CHARSET utf8mb4;"
mysql -uroot -p ovra_zero < bin/sql/ovra_zero.sql
```

2. 修改 `etc/dev/common.yaml` 中的数据库连接：

```yaml
Data:
  Database:
    Username: root
    Password: Pl@1221view    # 改为本机 MySQL 密码
    Host: 127.0.0.1
    Port: 3306
    Database: ovra_zero
    Ssl: false
```

默认管理员账号：`admin` / `admin123`

### Redis

修改 `etc/dev/common.yaml`：

```yaml
Data:
  Redis:
    Pass: Pl@1221view        # 改为本机 Redis 密码；无密码可留空
    Host: 127.0.0.1:6379
    Type: node               # 单机用 node；集群用 cluster
    Tls: false
```

本地启动 Redis 示例：

```sh
# 无密码
redis-server --port 6379

# 有密码（需与 common.yaml 中 Pass 一致）
redis-server --port 6379 --requirepass '你的密码'
```

Redis Cluster 示例：

```yaml
Data:
  Redis:
    Pass: your-password
    Host: host1:6379,host2:6379,host3:6379
    Type: cluster
    Tls: false
```

## 三、按需调整的配置

以下配置均在 `etc/dev/common.yaml`，本地开发通常可保持默认，对接前端或上生产时需关注。

| 配置项 | 默认值 | 说明 |
| --- | --- | --- |
| `JwtAuth.AccessSecret` | `YXTsYXMtYWRtaW4=` | JWT 签名密钥，生产环境务必修改 |
| `JwtAuth.AccessExpire` | `86400` | Token 过期时间（秒） |
| `JwtAuth.MultipleLoginDevices` | `false` | 是否允许同账号多设备登录 |
| `Tenant.Enabled` | `false` | 多租户开关 |
| `Captcha.Enabled` | `false` | 验证码开关 |
| `Sign.Enabled` | `false` | 接口签名校验 |
| `ApiDecrypt.Enabled` | `true` | 接口加解密 |
| `ApiDecrypt.PublicKey` | 内置 RSA 公钥 | 后端响应加密，对应前端 `VITE_GLOB_RSA_PRIVATE_KEY` |
| `ApiDecrypt.PrivateKey` | 内置 RSA 私钥 | 后端请求解密，对应前端 `VITE_GLOB_RSA_PUBLIC_KEY` |
| `Idempotency.Enabled` | `true` | 幂等中间件（依赖 Redis） |
| `Data.Cache.Expire` | `3600` | 内存缓存过期时间（秒） |

对接 [RuoYi-Plus-Vben5](https://gitee.com/dapppp/ruoyi-plus-vben5.git) 前端时，`ApiDecrypt` 的 RSA 密钥需与前端环境变量一致，否则登录和接口请求可能解密失败。

## 四、启动服务

### 推荐方式（直接 go run）

服务会自动读取 `etc/dev/*.yaml`：

```sh
# 启动 system（/auth 登录与总控业务 API 同一进程）
go run app/system/system.go

# demo 可选
go run app/demo/demo.go
```

显式指定配置文件：

```sh
go run app/system/system.go -f etc/dev/system.yaml
```

### 构建后后台运行

```sh
make build-all
make back-all
```

### 启动 Traefik 网关（前端联调必启）

Traefik 配置：

```text
bin/traefik/traefik.yaml      # 入口端口 28080，Dashboard 28090
bin/traefik/dynamic.yaml      # 路由到 system/demo
```

#### 前置条件

先启动后端服务（网关只做转发，本身不跑业务）：

```sh
go run app/system/system.go   # 8086（含 /auth）
# demo 可选：8099
```

#### 启动命令

必须在**项目根目录**执行（配置里用了相对路径 `./bin/traefik/...`）：

```sh
cd /path/to/ovra-zero
make traefik-run
```

等价于：

```sh
./bin/traefik/traefik --configfile=./bin/traefik/traefik.yaml
```

该命令会**占用当前终端**（前台运行）。另开终端做其他操作，或后台运行：

```sh
nohup make traefik-run > traefik.log 2>&1 &
```

#### macOS：首次运行可能被系统拦截

若出现 `Killed: 9` 且 `28080` 无监听，多半是 `bin/traefik/traefik` 带有下载隔离属性。解除后重试：

```sh
xattr -d com.apple.quarantine bin/traefik/traefik
make traefik-run
```

也可在「系统设置 → 隐私与安全性」中允许该程序运行。

#### 关于 `_encode: command not found: -e`

若终端里反复出现 `_encode:25: command not found: -e`，这是 **zsh 环境**（如某个插件/主题里的 `_encode` 函数）的问题，**不是** Ovra-Zero 或 Traefik 报错，一般可忽略。不影响 `make traefik-run` 实际执行的命令。

想消除可在 `~/.zshrc` 里排查 `_encode` 相关配置，或换用干净 shell：

```sh
/bin/bash -lc 'cd /path/to/ovra-zero && make traefik-run'
```

#### 验证网关

```sh
curl http://127.0.0.1:28080/auth/code
# 期望 HTTP 200

# Traefik Dashboard（可选）
open http://127.0.0.1:28090
```

#### 路由表

| 网关路径 | 转发到 |
| --- | --- |
| `/auth/*`、`/system/*`、`/monitor/*`、`/resource/*`、`/member/*`、`/fund/*`、`/trade/*`、`/invest/*`、`/product/*`、`/notify/*`、`/kline/*`、`/app/*`、`/dashboard/*` | `http://127.0.0.1:8086` |
| `/demo/*` | `http://127.0.0.1:8099` |

路由规则定义在 `bin/traefik/dynamic.yaml` 的 `router-system`。新增 system 服务上的 API 前缀时，须同步更新该文件并重启 Traefik。

验证业务接口（需 system 与 Traefik 已启动）：

```sh
curl -s -o /dev/null -w "%{http_code}\n" \
  'http://127.0.0.1:28080/member/user/list?pageNum=1&pageSize=10'
# 期望 200 或 401，不应为 404
```

前端 `vite.config.ts` 将 `/api` 代理到 `http://127.0.0.1:28080`（`rewrite` 去掉 `/api` 前缀）。

### 关于 Makefile 的 run 命令

`make run-system` 默认读取 `etc/system.yaml`；本地开发请使用：

```sh
ENV=dev go run app/system/system.go
# 或
go run app/system/system.go -f etc/dev/system.yaml
```

## 五、验证启动

```sh
# 经 Traefik
curl http://127.0.0.1:28080/auth/code

# 直接访问 system 服务
curl http://127.0.0.1:8086/auth/code
```

## 六、其他说明

### OSS / 文件上传

文件存储配置在数据库表 `sys_oss_config` 中，初始化数据默认包含 MinIO（`127.0.0.1:9000`）。如需使用文件上传，需单独部署 MinIO 或对象存储，并在后台或数据库中更新对应配置。

### 代码生成配置

`gen/system/gen.yaml` 与 `gen/demo/gen.yaml` 中的 DSN 仅用于 `make db-*` 生成数据库代码，**不影响服务运行**。若需重新生成 DAL 代码，请将 DSN 改为与本机 MySQL 一致。

### 最小启动清单

本地跑通登录，至少需要：

1. 修改 `etc/dev/common.yaml` 中的 **MySQL** 与 **Redis** 连接信息
2. 导入 `bin/sql/ovra_zero.sql`
3. 启动 **system**（demo 可选）
4. 对接前端时确认 **ApiDecrypt RSA 密钥**与前端一致

## 七、对接 RuoYi-Plus-Vben5 前端

前端项目位于 `ruoyi-plus-vben5/apps/web-antd`，开发端口默认 `5666`，通过 Vite 代理将 `/api` 转发到后端。

### 代理配置

前端**统一经 Traefik 网关**转发，不直连后端端口。`apps/web-antd/vite.config.ts` 默认：

```ts
'/api': {
  changeOrigin: true,
  rewrite: (path) => path.replace(/^\/api/, ''),
  target: 'http://127.0.0.1:28080',
  ws: true,
},
```

**不要**指向 RuoYi 单体版默认的 `localhost:8080`。

### 启动顺序（前端联调）

1. 启动 **system**（8086）
2. 启动 **Traefik**：`make traefik-run`（28080）
3. 启动前端：`pnpm dev:antd`（5666）

网关路由表见上文「启动 Traefik 网关 → 路由表」。若 `/api/member/*` 返回 404，检查 `bin/traefik/dynamic.yaml` 是否包含对应 `PathPrefix`，并重启 Traefik。

### 网关 vs 直连

| 场景 | 方式 |
| --- | --- |
| **本地前端开发（本项目默认）** | Vite `/api` → Traefik `28080` → 各服务 |
| **调试单个服务（curl/Postman）** | 可直连 `8086`，与前端代理无关 |
| **k3d / Helm 部署** | Ingress 统一入口，见 `deploy/helm/ovra-zero` |

### RSA 加解密如何与后端一致

加解密使用 **两对** RSA 密钥，各自负责一个方向（`common.yaml` 内注释已标明）：

| 方向 | 前端（`.env.development`） | 后端（`common.yaml` → `ApiDecrypt`） |
| --- | --- | --- |
| 请求：前端加密 → 后端解密 | `VITE_GLOB_RSA_PUBLIC_KEY`（公钥） | `PrivateKey`（私钥） |
| 响应：后端加密 → 前端解密 | `VITE_GLOB_RSA_PRIVATE_KEY`（私钥） | `PublicKey`（公钥） |

流程简述：前端用 RSA 公钥加密 AES 密钥放入 `encrypt-key` 头，请求体用 AES 加密；后端用 `PrivateKey` 解密。响应方向相反。

#### 密钥格式

- **后端**：Base64 编码的 DER（`PrivateKey` 多为 PKCS#8，`PublicKey` 为 PKIX）
- **前端**：JSEncrypt 使用 **DER 的 Base64**（如 `MIIBIjANBgkqhkiG9w0...`），**不要**用 `LS0tLS1CRUdJTi...`（那是 Base64 编码的 PEM，会报 `RsaEncryption encrypt error`）

当前仓库里 `common.yaml` 只保存了后端侧密钥；前端 `.env.development` 仍是 RuoYi 模板默认钥，**与 Ovra-Zero 后端不是同一套**，需要重新对齐。

#### 方式一：重新生成两对密钥（推荐）

在项目根目录执行：

```bash
go run ./scripts/gen-api-rsa-keys.go
```

将输出分别填入：

- `etc/dev/common.yaml` → `ApiDecrypt.PrivateKey`、`ApiDecrypt.PublicKey`
- `ruoyi-plus-vben5/apps/web-antd/.env.development` → `VITE_GLOB_RSA_PUBLIC_KEY`、`VITE_GLOB_RSA_PRIVATE_KEY`

修改后重启 **后端服务** 与 **`pnpm dev:antd`**。

#### 方式二：从现有后端私钥导出请求方向公钥

若只想复用 `common.yaml` 里已有的 `ApiDecrypt.PrivateKey`，可导出对应公钥给前端：

```bash
# 将 common.yaml 中 PrivateKey 的值写入 priv.b64（单行）
base64 -d -i priv.b64 -o priv.der
openssl rsa -inform DER -in priv.der -pubout -outform DER | base64 | tr -d '\n'
```

输出填入 `VITE_GLOB_RSA_PUBLIC_KEY`。

**注意**：`ApiDecrypt.PublicKey` 对应的私钥未保存在仓库中，响应方向无法单靠后端配置反推。若登录后接口仍报响应解密失败，请用方式一完整重生成两对密钥。

#### 方式三：本地临时关闭加密（最快验证）

前端 `.env.development`：

```properties
VITE_GLOB_ENABLE_ENCRYPT=false
```

后端 `ApiDecrypt.Enabled` 可保持 `true`：未携带 `encrypt-key` 请求头时，中间件会跳过加解密。

### 实时消息（SSE / WebSocket）

RuoYi-Plus-Vben5 登录后会连接 `GET /resource/sse` 接收站内通知。**Ovra-Zero 当前未实现该接口**，开启后控制台会反复出现 `404` 与 `sse重连失败`。

本地开发请在 `.env.development` 关闭：

```properties
VITE_GLOB_SSE_ENABLE=false
VITE_GLOB_WEBSOCKET_ENABLE=false
```

修改后需重启 `pnpm dev:antd`。不影响登录与常规 CRUD，仅无实时推送通知。

### 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `/api/member/*` 404 | Traefik 未启动，或 `dynamic.yaml` 缺少 `/member` 等 PathPrefix | `make traefik-run`；确认 `bin/traefik/dynamic.yaml` 后重启网关 |
| `502 Bad Gateway`（`/api/auth/login`） | Vite 代理目标不可达（如 system 未启动） | 确保 system 已启动 |
| 请求加密密钥解密失败 | 前后端 RSA 密钥不一致 | 对齐 `.env.development` 与 `common.yaml` 的密钥，或关闭加密 |
| `/api/resource/sse` 404、`sse重连失败` | 后端未实现 SSE | `.env.development` 设 `VITE_GLOB_SSE_ENABLE=false` 并重启前端 |

## 相关文档

- [接口代码跟读指南](./read-api-flow.md)（从 HTTP 到 Logic/DAL 的 onboarding 清单，以用户列表为例）
- [业务 API 接口文档](./biz-api.md)（用户管理～K线管理，含响应 JSON 占位）
- [项目 README](../README.md)
- [Helm / k3d 部署](../deploy/helm/ovra-zero/README.md)
- [配置目录说明](../etc/README.md)
