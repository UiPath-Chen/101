### 跨平台构建
> 平台列表
```bash
go tool dist list
```
>aix/ppc64
android/386
android/amd64
android/arm
android/arm64
darwin/amd64
darwin/arm64
dragonfly/amd64
freebsd/386
freebsd/amd64
freebsd/arm
freebsd/arm64
freebsd/riscv64
illumos/amd64
ios/amd64
ios/arm64
js/wasm
linux/386
linux/amd64
linux/arm
linux/arm64
linux/loong64
linux/mips
linux/mips64
linux/mips64le
linux/mipsle
linux/ppc64
linux/ppc64le
linux/riscv64
linux/s390x
netbsd/386
netbsd/amd64
netbsd/arm
netbsd/arm64
openbsd/386
openbsd/amd64
openbsd/arm
openbsd/arm64
plan9/386
plan9/amd64
plan9/arm
solaris/amd64
wasip1/wasm
windows/386
windows/amd64
windows/arm
windows/arm64

```bash
docker buildx build \ # DOCKER_BUILDKIT=1 docker build \
--push \
--platform=linux/amd64,linux/arm64 \
--tag harbor.poc.devopscamp.uk/example/camp-go-example:dev-111 \
-f Dockerfile .
```

> 查看构建过程产生的中间镜像

```bash
docker history test:v1.0
```
> ERROR: Multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")
make: *** [Makefile:11: release] Error 1

```bash
docker buildx ls

docker buildx create --use
```