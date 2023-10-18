## nodefs
系统分区：工作目录（数据）和容器日志
### containerd & docker 软件

`/var/lib/kubelet/pods/ecbbaf5e-c7f1-4f00-8627-454f03cfbb4d`

## imagefs
容器运行时分区：
- 用户镜像和容器可写层
- 容器运行时分区时可选的，可以合并到系统分区中。

### containerd 软件

`/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs`

### docker

`/var/lib/docker/overlay2/`

## Eviction configuration
```bash
ps -ef |grep kubelet
--config=/var/lib/kubelet/config.yaml
```
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
evictionHard:        # 硬驱逐，小于以下
  memory.available: '500Mi'
  nodefs.available: '1Gi'
  imagefs.available: '100Gi'
evictionMinimumReclaim:    # 每次至少驱逐多少
  memory.available: '0Mi'
  nodefs.available: '500Mi'
  imagefs.available: '2Gi'
```
