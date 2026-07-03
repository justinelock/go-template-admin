# Docker 重启后本地 k3d 服务恢复手册

本文档用于处理本地 Docker Desktop 或 Docker daemon 重启后，`ovra-zero` 在 k3d 中出现服务不可用的问题。

适用场景：

- `curl http://ovra-zero.localhost:18080/auth/code` 返回 `no available server`
- 应用 Pod `CrashLoopBackOff`
- Redis Pod 状态异常
- MySQL EndpointSlice 指向了错误 IP
- k3d 节点变成 `NotReady`

> **架构说明**：总控已单体化，`/auth` 由 **system** 提供，集群内**无 etcd、无 auth Deployment**。

## 一、快速体检

### 1. 检查 Docker 容器

```sh
docker ps --format '{{.Names}} {{.Status}} {{.Networks}}'
```

重点确认：

```text
k3d-ovra-server-0
k3d-ovra-agent-0
k3d-ovra-agent-1
k3d-ovra-serverlb
ovra-zero-mysql
```

### 2. 检查 k3d 集群

```sh
k3d cluster list
kubectl get nodes -o wide
```

### 3. 检查业务资源

```sh
kubectl -n ovra-zero get pods,svc,statefulset,ingress,endpointslice
helm status ovra-zero -n ovra-zero
```

正常状态应类似：

```text
system    1/1 Running
demo      1/1 Running
redis-0   1/1 Running
redis-1   1/1 Running
redis-2   1/1 Running

statefulset.apps/redis   3/3
```

## 二、恢复 k3d 节点

若节点 `NotReady`：

```sh
docker restart k3d-ovra-agent-1   # 按实际异常节点调整
kubectl get nodes -o wide
```

## 三、修复 MySQL EndpointSlice

Docker 重启后 `ovra-zero-mysql` 的 IP 可能变化。

```sh
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ovra-zero-mysql)
echo "MySQL IP: ${MYSQL_IP}"

helm upgrade ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --set mysql.external.ip=${MYSQL_IP} \
  --wait \
  --timeout 5m

kubectl -n ovra-zero get endpointslice mysql-external
```

## 四、恢复 Redis Cluster

Docker 重启后，本地 `emptyDir` 模式下 Redis Cluster 可能出现 slot 丢失。

常见错误：`CLUSTERDOWN`、`cluster_state:fail`、`cluster_slots_assigned:0`

```sh
kubectl -n ovra-zero delete statefulset redis --ignore-not-found
kubectl -n ovra-zero delete pod -l app.kubernetes.io/component=redis --ignore-not-found
kubectl -n ovra-zero delete job redis-cluster-init --ignore-not-found

helm upgrade ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --set mysql.external.ip=${MYSQL_IP} \
  --wait \
  --timeout 5m
```

验证：

```sh
kubectl -n ovra-zero exec redis-0 -- redis-cli -a 'Pl@1221view' cluster info
```

期望 `cluster_state:ok`、`cluster_slots_assigned:16384`。

## 五、重启应用服务

MySQL、Redis 恢复后重启应用：

```sh
kubectl -n ovra-zero rollout restart deployment/system deployment/demo
kubectl -n ovra-zero rollout status deployment/system --timeout=180s
kubectl -n ovra-zero rollout status deployment/demo --timeout=180s
```

## 六、最终验证

```sh
kubectl -n ovra-zero get pods,svc,ingress
curl -sS http://ovra-zero.localhost:18080/auth/code
```

## 七、一键恢复命令

```sh
docker restart k3d-ovra-agent-1 || true

MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ovra-zero-mysql)
echo "MySQL IP: ${MYSQL_IP}"

helm upgrade ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --set mysql.external.ip=${MYSQL_IP} \
  --wait \
  --timeout 5m || true

kubectl -n ovra-zero delete statefulset redis --ignore-not-found
kubectl -n ovra-zero delete pod -l app.kubernetes.io/component=redis --ignore-not-found
kubectl -n ovra-zero delete job redis-cluster-init --ignore-not-found

helm upgrade ovra-zero deploy/helm/ovra-zero \
  --namespace ovra-zero \
  --set mysql.external.ip=${MYSQL_IP} \
  --wait \
  --timeout 5m

kubectl -n ovra-zero rollout restart deployment/system deployment/demo
kubectl -n ovra-zero rollout status deployment/system --timeout=180s

curl -sS http://ovra-zero.localhost:18080/auth/code
```

## 八、为什么 Docker 重启后会这样

- 本地 Redis 使用 `emptyDir`，Pod 重建后 cluster 元数据可能不一致
- 外部 MySQL 在 Docker bridge 网络中 IP 会变，需更新 `mysql.external.ip`

生产环境建议：Redis/MySQL 使用 PVC 或托管服务，不依赖动态 Docker IP。
