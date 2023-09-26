https://kubernetes.io/zh/docs/setup/production-environment/container-runtimes/#containerd

### Stop service

```sh
systemctl stop kubelet
systemctl stop docker.socket
systemctl stop docker.service
systemctl stop containerd

for svc in kubelet docker.socket docker.service containerd;do systemctl stop ${svc};done
```

### Create containerd config folder & Update default config


```sh
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

nano /etc/containerd/config.toml

# 为什么要做注释掉，如果你的网络能拉取gcr.io上的镜像，可以跳过；否则，请使用国内镜像
#
# sandbox_image = "registry.k8s.io/pause:3.6"    <<默认>>
# sandbox_image = "k8s.gcr.io/pause:3.5"    <<国外推荐>>
# sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.5" <<国内推荐>>
#

sed -i s#registry.k8s.io/pause:3.6#registry.aliyuncs.com/google_containers/pause:3.5#g /etc/containerd/config.toml

#
# 配置Cgroup启动方式：systemd
#
sed -i s#'SystemdCgroup = false'#'SystemdCgroup = true'#g /etc/containerd/config.toml
```

### Edit kubelet config and add extra args
告诉kubelet，配置的containerd在哪里

```sh
# 配置kubelet daemon
#
# nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.5"

nano /var/lib/kubelet/kubeadm-flags.env

KUBELET_KUBEADM_ARGS="--network-plugin=cni --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.5"
KUBELET_EXTRA_ARGS="--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
#
# 重新加载一下
#
# systemctl daemon-reload
```

### Restart

```sh
systemctl daemon-reload
systemctl restart containerd
systemctl restart kubelet

for svc in containerd kubelet;do systemctl restart ${svc};done

journalctl -xeu containerd.service


# 检测是否切换成功
systemctl status kubelet

```
### crictl - client for CRI
```sh
#
# Config crictl to set correct endpoint
#
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF

crictl images/ps(容器进程)/pods(sandbox进程)/inspect <container id>/inspectp <pod id>/inspecti <image id>
docker images/ps
``````