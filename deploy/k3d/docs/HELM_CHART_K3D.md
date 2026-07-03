# Ovra-Zero Helm Chart 说明文档

本文档说明 `deploy/helm/ovra-zero` 的结构、配置、安装与维护。当前架构为**总控单体化**：`system` 同时提供 `/auth/*` 与业务 API，**无需 etcd、无需独立 auth 进程**。

## 一、Chart 目录结构

```text
deploy/helm/ovra-zero
├── Chart.yaml
├── values.yaml
├── README.md
├── INSTALL_REDIS.md
├── files/config
│   ├── common.yaml.gotmpl
│   ├── system.yaml.gotmpl
│   └── demo.yaml.gotmpl
└── templates
    ├── _helpers.tpl
    ├── apps.yaml
    ├── configmap.yaml
    ├── ingress.yaml
    ├── mysql.yaml
    └── redis.yaml
```

| 文件 | 作用 |
| --- | --- |
| `values.yaml` | 镜像、MySQL、Redis、system/demo 服务、Ingress |
| `files/config/*.gotmpl` | 应用配置模板（Redis Cluster 地址等由 `tpl` 渲染） |
| `apps.yaml` | system、demo 的 Deployment 与 Service |
| `configmap.yaml` | 渲染为 `ovra-zero-config` ConfigMap |
| `redis.yaml` | Redis Cluster StatefulSet 与初始化 Job |
| `mysql.yaml` | 外部 EndpointSlice 或内置 MySQL |
| `ingress.yaml` | 统一入口路由 |

## 二、应用服务

`values.services` 默认启用：

| 服务 | 命令 | HTTP 端口 | 说明 |
| --- | --- | --- | --- |
| `system` | `/app/app-system` | 8086 | 含 `/auth/login`、`/system/*`、`/member/*` 等 |
| `demo` | `/app/app-demo` | 8099 | 示例模块 |

容器共用镜像 `ovra-zero:local`，配置挂载于 `config.mountPath`（默认 `/app/etc/config`），环境变量 `ENV=k3d` 时读取 `system.yaml`、`demo.yaml`、`common.yaml`。

ConfigMap 变更时，`apps.yaml` 中的 `checksum/config` 注解会触发 Deployment 滚动更新。

## 三、依赖组件

### Redis Cluster

- StatefulSet 3 节点 + `redis-cluster-init` Job
- 应用 `Data.Redis.Type: cluster`，Host 为逗号分隔的 headless 地址
- 详见 [INSTALL_REDIS.md](../INSTALL_REDIS.md)

### MySQL

- **默认**：外部 Docker 容器 + `EndpointSlice`（`mysql.external.ip`）
- **可选**：Chart 内置 MySQL Deployment（开发用 `emptyDir`）

## 四、Ingress 路由

默认 host：`ovra-zero.localhost`（k3d 映射端口 `18080`）

| Path | Service | 端口 |
| --- | --- | --- |
| `/auth` | system | 8086 |
| `/system`、`/monitor`、`/resource` | system | 8086 |
| `/demo` | demo | 8099 |

业务路径（`/member`、`/fund` 等）可按需在 `values.yaml` 的 `ingress.paths` 中扩展；本地开发亦可用 Traefik（见 `bin/traefik/dynamic.yaml`）。

## 五、安装前准备

### 构建镜像

```sh
mkdir -p .deploy/k3d/bin

GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build \
  -ldflags='-s -w' -tags no_k8s \
  -o .deploy/k3d/bin/app-system app/system/system.go

GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build \
  -ldflags='-s -w' -tags no_k8s \
  -o .deploy/k3d/bin/app-demo app/demo/demo.go

docker build --platform linux/arm64 -t ovra-zero:local -f deploy/k3d/Dockerfile .
k3d image import ovra-zero:local -c ovra
```

x86_64 将 `GOARCH=arm64` / `--platform linux/arm64` 改为 `amd64`。

### 外部 MySQL

```sh
docker run -d --name ovra-zero-mysql --network k3d-ovra \
  -e MYSQL_ROOT_PASSWORD='Pl@1221view' \
  -e MYSQL_DATABASE=ovra_zero \
  -v "$PWD/bin/sql/ovra_zero.sql:/docker-entrypoint-initdb.d/ovra_zero.sql:ro" \
  mysql:8.4
```

安装时覆盖 IP：

```sh
helm upgrade --install ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --create-namespace \
  --set mysql.external.ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ovra-zero-mysql) \
  --wait --timeout 5m
```

亦可使用脚本：`scripts/deploy-k3d.sh`。

## 六、安装 / 升级 / 回滚

```sh
# 安装或升级
helm upgrade --install ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero --create-namespace --wait --timeout 5m

# 渲染校验
helm lint deploy/helm/ovra-zero
helm template ovra-zero deploy/helm/ovra-zero --namespace ovra-zero

# 回滚
helm history ovra-zero -n ovra-zero
helm rollback ovra-zero <REVISION> -n ovra-zero

# 卸载
helm uninstall ovra-zero -n ovra-zero
```

## 七、常见配置调整

- **镜像**：`image.repository` / `image.tag`
- **Ingress 域名**：`ingress.host`
- **关闭 demo**：`services.demo.enabled: false`
- **Redis 节点数**：`redis.cluster.replicas`（开发环境改后需重建 StatefulSet，见 INSTALL_REDIS.md）
- **内置 MySQL**：`mysql.internal.enabled: true`

## 八、验证

```sh
kubectl -n ovra-zero get pods,svc,ingress
kubectl -n ovra-zero rollout status deployment/system
kubectl -n ovra-zero exec redis-0 -- redis-cli -a 'Pl@1221view' cluster info

curl -sS http://ovra-zero.localhost:18080/auth/code
```

## 九、排障

| 现象 | 处理 |
| --- | --- |
| MySQL 连接失败 | 检查 `mysql.external.ip` 与 Docker 容器 IP 是否一致 |
| Redis `cluster_state:fail` | 重建 Redis StatefulSet 与 init Job（见 RECOVERY 文档） |
| Pod 使用旧配置 | `kubectl rollout restart deployment/system` |
| `/auth/code` 502 | 确认 `system` Pod Running，Ingress 指向 8086 |

Docker 重启后的恢复步骤见 [RECOVERY_AFTER_DOCKER_RESTART.md](./RECOVERY_AFTER_DOCKER_RESTART.md)。

## 十、生产环境建议

- Redis / MySQL 使用 PVC 或托管服务
- Redis 密码写入 Secret
- Ingress 配置 TLS 与正式域名
- 为应用设置 resources 与探针
