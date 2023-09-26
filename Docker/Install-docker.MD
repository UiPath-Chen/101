### Ubuntu
https://docs.docker.com/engine/install/ubuntu/

### Cleanup
```bash
# Uninstall old versions
# 非官方的包：docker.io docker-compose docker-doc podman-docker
# 依赖 - containerd.io： containerd/runc

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# 推荐：Uninstall Docker Engine, CLI, containerd, and Docker Compose packages
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
## To delete all images, containers, and volumes
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```
### APT Install
```bash
# 1. Set up the repository
# 1.1 Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# 1.2 Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 1.3 Set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 1.4 Update the apt package index
sudo apt-get update

# 2. Install Docker Engine
# 2.1 Install Docker Engine, containerd, and Docker Compose
# 2.1.1 Latest
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# 2.1.2 Specific version

# 2.2 Verify that the Docker Engine installation is successful by running the hello-world image
## This command downloads a test image and runs it in a container. When the container runs, it prints a confirmation message and exits
sudo docker run hello-world
# 参考以下,学习启动docker run的过程
``````
验证
```bash
docker run hello-world
```
Docker
   - image
   - container
   - client
   - daemon
   - hub

```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
719385e32844: Pull complete
Digest: sha256:dcba6daec718f547568c562956fa47e1b03673dd010fe6ee58ca806767031d1c
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
``````

### Script Install
推荐安装在开发环境，不推荐安装在生成环境；但是可以作为一个定制脚本，专门满足你的定制化需求；
注意：默认情况下，这种方式完全就是APT Install方式的脚本化
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh [--dry-run]

# 简化一下
curl -fsSL https://get.docker.com | bash -s

# 验证
sudo docker run hello-world
``````
### Post-Install
https://docs.docker.com/engine/install/linux-postinstall/

#### Manage Docker as a non-root user
```bash
sudo groupadd docker
sudo usermod -aG docker $USER

# 激活
# 1. 退出,重新登录
# 2. 虚拟机重启
# 3. 下面的命令
newgrp docker

# 验证
docker run hello-world
``````
#### Configure Docker to start on boot with systemd

> https://github.com/moby/moby/tree/master/contrib/init/systemd
> Unit:
>  - docker.service
>  - docker.socket
> /etc/systemd/system/

Debian and Ubuntu: 默认自启动
Other: 看下面

```bash
sudo systemctl enable docker.service
sudo systemctl disable docker.service

sudo systemctl enable containerd.service
sudo systemctl disable containerd.service

docker info
# 检查Cgroup Driver: systemd, 如果是cgroupfs
sudo systemctl daemon-reload
systemctl stop docker.socket
systemctl restart docker
``````
### Docker Hub
注册：https://hub.docker.com/
dockerkeystone
ysu130525
```bash
# 在本地linux登录hub.docker.com
docker login

# 推送到hub.docker.com
docker push dockerHub名称/镜像名称:v1.0
``````

### 后台代理

方式一：环境变量
> HTTP_PROXY
http_proxy
HTTPS_PROXY
https_proxy
NO_PROXY
no_proxy

方式二：/etc/daemon.json
```json


{
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "*.test.example.com,.example.org,127.0.0.0/8"
  }
}
``````

方式三：如果开启全局代理，不可以使用daemon.json或环境变量
```bash
sudo mkdir -p /etc/systemd/system/docker.service.d

# /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:3128"

# set the HTTPS_PROXY environment variable
[Service]
Environment="HTTPS_PROXY=https://proxy.example.com:3129"

# set both a non-HTTPS and a HTTPs proxy
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:3128"
Environment="HTTPS_PROXY=https://proxy.example.com:3129"

#
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:3128"
Environment="HTTPS_PROXY=https://proxy.example.com:3129"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
``````

刷新更新、重启docker
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker

# 验证
sudo systemctl show --property=Environment docker
手动配置systemd集成
``````


