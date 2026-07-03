# Redis Cluster 安装部署文档

本文档说明 Ovra-Zero 使用的 Redis Cluster 安装方式，覆盖：

- Kubernetes / Helm 部署
- Linux 裸机 systemd 部署

> **架构说明**：总控已单体化（`/auth` 与业务 API 均在 `system` 进程内），**不再依赖 etcd**。应用只需 MySQL + Redis。

当前默认拓扑：

- Redis：3 节点 Redis Cluster，3 个 master，0 个 replica

> 3 节点 Redis Cluster 可完成槽位分片，但没有 Redis 层面的副本容灾。生产环境建议使用 6 节点：3 master + 3 replica。

## 一、端口与拓扑

### Kubernetes 拓扑

| 组件 | 资源类型 | 副本数 | 端口 | Service |
| --- | --- | ---: | --- | --- |
| Redis | StatefulSet | 3 | `6379` client，`16379` cluster bus | `redis`，`redis-headless` |
| system | Deployment | 1 | `8086` HTTP（含 `/auth/*`） | `system` |
| demo | Deployment | 1 | `8099` HTTP | `demo` |

Helm 会自动渲染应用配置：

- Redis 配置为 `Type: cluster`
- go-zero 的 `RedisConf` 要求 Cluster 地址写成一个逗号分隔字符串，Helm 将 3 个 Redis 节点渲染到同一 `Host` 字段

### Linux 裸机示例拓扑

| 节点 | IP | Redis 角色 |
| --- | --- | --- |
| node1 | `10.0.0.11` | master |
| node2 | `10.0.0.12` | master |
| node3 | `10.0.0.13` | master |

需开放端口：`6379/tcp`、`16379/tcp`

## 二、Helm 部署

### 1. 配置项

```text
deploy/helm/ovra-zero/values.yaml
```

关键配置：

```yaml
redis:
  password: Pl@1221view
  port: 6379
  busPort: 16379
  cluster:
    enabled: true
    replicas: 3
    replicasPerMaster: 0
```

### 2. 安装

```sh
helm upgrade --install ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --create-namespace \
  --wait \
  --timeout 5m
```

### 3. 验证 Redis Cluster

```sh
kubectl -n ovra-zero get statefulset redis
kubectl -n ovra-zero exec redis-0 -- redis-cli -a 'Pl@1221view' cluster info
kubectl -n ovra-zero exec redis-0 -- redis-cli -a 'Pl@1221view' cluster nodes
```

期望：

```text
cluster_state:ok
cluster_slots_assigned:16384
```

### 4. 修改 Redis 节点数后重建（开发环境）

```sh
kubectl -n ovra-zero delete statefulset redis --ignore-not-found
kubectl -n ovra-zero delete pod -l app.kubernetes.io/component=redis --ignore-not-found
kubectl -n ovra-zero delete job redis-cluster-init --ignore-not-found

helm upgrade ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --wait \
  --timeout 5m
```

## 三、Linux 裸机部署 Redis Cluster

### 1. 安装 Redis

Debian/Ubuntu：`apt-get install -y redis-server`  
RHEL/CentOS：`dnf install -y redis`

### 2. 节点配置示例（node1）

```conf
bind 10.0.0.11
port 6379
requirepass Pl@1221view
masterauth Pl@1221view
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip 10.0.0.11
cluster-announce-port 6379
cluster-announce-bus-port 16379
appendonly yes
dir /var/lib/redis
```

node2/node3 替换 IP 即可。

### 3. 创建 Cluster

```sh
redis-cli -a 'Pl@1221view' --cluster create \
  10.0.0.11:6379 10.0.0.12:6379 10.0.0.13:6379 \
  --cluster-replicas 0 --cluster-yes
```

### 4. Ovra-Zero 配置

`etc/dev/common.yaml` 或 Helm `common.yaml.gotmpl`：

```yaml
Data:
  Redis:
    Pass: Pl@1221view
    Host: 10.0.0.11:6379,10.0.0.12:6379,10.0.0.13:6379
    Type: cluster
    Tls: false
```

本地单机开发可用 `Type: node`、`Host: 127.0.0.1:6379`。

## 四、常用运维命令

```sh
# K8s
kubectl -n ovra-zero exec redis-0 -- redis-cli -a 'Pl@1221view' cluster info

# 裸机
journalctl -u redis-server -f
redis-cli -h 10.0.0.11 -p 6379 -a 'Pl@1221view' --cluster check 10.0.0.11:6379
```

## 五、生产环境建议

- Kubernetes 使用 PVC，不要用 `emptyDir` 持久化 Redis 数据
- Redis 建议 6 节点：3 master + 3 replica
- 密码使用 Secret，不要明文写在 values
- 启用 chrony/ntpd 保持时间同步
