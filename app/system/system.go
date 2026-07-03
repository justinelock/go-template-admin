package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"ovra/app/system/internal/config"
	"ovra/app/system/internal/handler"
	"ovra/app/system/internal/middleware"
	"ovra/app/system/internal/svc"
	"ovra/toolkit/configloader"
	"ovra/toolkit/helper"
	"ovra/toolkit/middlewares"
	"ovra/toolkit/utils"
	"path/filepath"

	"github.com/zeromicro/go-zero/core/service"
	"github.com/zeromicro/go-zero/rest"
	"github.com/zeromicro/go-zero/rest/httpx"
)

var configFile *string

func init() {
	env := os.Getenv("ENV")
	if env == "" {
		env = "dev"
	}
	defaultConfig := filepath.Join("etc", env, "system.yaml")
	configFile = flag.String("f", defaultConfig, "the config file")
	flag.Parse()
	fmt.Println("Using config file:", *configFile)
}

func main() {
	flag.Parse()
	if err := utils.Init("2024-01-01", 1); err != nil {
		fmt.Printf("init snowflake failed, err:%v\n", err)
		return
	}
	var c config.Config
	configloader.MustLoad(*configFile, &c)

	server := rest.MustNewServer(c.RestConf, rest.WithCustomCors(apiEncryptCors, nil, "*"))

	httpx.SetOkHandler(helper.OkHandler)
	httpx.SetErrorHandlerCtx(helper.ErrHandler(c.RestConf.Name))

	ctx := svc.NewServiceContext(c)
	handler.RegisterHandlers(server, ctx)
	server.Use(middlewares.ApiEncryptMiddleware(c.ApiDecrypt))
	server.Use(middlewares.IdempotencyMiddleware(ctx.Rds, middlewares.IdempotencyConfig(c.Idempotency)))
	server.Use(middleware.LogMiddleware)
	server.Use(middlewares.ApiMiddleware(c.RestConf.Mode))

	group := service.NewServiceGroup()
	group.Add(server)
	defer group.Stop()
	fmt.Printf("Starting server at %s:%d...\n", c.RestConf.Host, c.RestConf.Port)
	group.Start()
}

func apiEncryptCors(header http.Header) {
	header.Set("Access-Control-Allow-Headers", "Content-Type, Origin, X-CSRF-Token, Authorization, AccessToken, Token, Range, ClientID, encrypt-key")
	header.Set("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, encrypt-key")
}
