// 生成前后端 ApiDecrypt 对齐用的两对 RSA 密钥。
//
// 用法: go run ./scripts/gen-api-rsa-keys.go
package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/base64"
	"fmt"
)

func backendPrivateKey(key *rsa.PrivateKey) string {
	der, err := x509.MarshalPKCS8PrivateKey(key)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(der)
}

func backendPublicKey(key *rsa.PublicKey) string {
	der, err := x509.MarshalPKIXPublicKey(key)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(der)
}

func frontendPublicKey(key *rsa.PublicKey) string {
	der, err := x509.MarshalPKIXPublicKey(key)
	if err != nil {
		panic(err)
	}
	// JSEncrypt 使用 PKIX DER 的 Base64，不要 Base64(PEM)
	return base64.StdEncoding.EncodeToString(der)
}

func frontendPrivateKey(key *rsa.PrivateKey) string {
	der := x509.MarshalPKCS1PrivateKey(key)
	// JSEncrypt 使用 PKCS#1 DER 的 Base64
	return base64.StdEncoding.EncodeToString(der)
}

func main() {
	requestKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		panic(err)
	}
	responseKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		panic(err)
	}

	fmt.Println("将以下内容写入 etc/dev/common.yaml → ApiDecrypt：")
	fmt.Println()
	fmt.Println("  PrivateKey:", backendPrivateKey(requestKey))
	fmt.Println("  PublicKey:", backendPublicKey(&responseKey.PublicKey))
	fmt.Println()
	fmt.Println("将以下内容写入 ruoyi-plus-vben5/apps/web-antd/.env.development：")
	fmt.Println()
	fmt.Println("  VITE_GLOB_RSA_PUBLIC_KEY=" + frontendPublicKey(&requestKey.PublicKey))
	fmt.Println("  VITE_GLOB_RSA_PRIVATE_KEY=" + frontendPrivateKey(responseKey))
	fmt.Println()
	fmt.Println("完成后重启后端服务与 pnpm dev:antd。")
}
