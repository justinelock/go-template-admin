# 配置目录

本地开发配置位于 `etc/dev/`，详细启动说明见 [docs/local-dev.md](../docs/local-dev.md)。

## 服务端口

| 模块名称 | REST端口 | Prometheus |
|----------|----------|------------|
| system   | 8086     | 4002       |
| demo     | 8099     | 4009       |

`system` 同时提供 `/auth/*`（登录、验证码、租户列表）与总控业务 API。

## 新建模块
```shell
goctl api new demo --style go_zero
```
