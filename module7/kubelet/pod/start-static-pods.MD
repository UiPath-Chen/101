### 静态Pod
使用kubeadmin 启动K8S，那么kubelet是由systemd拉起来的进程

```bash

ps -ef |grep kubelet
--config=/var/lib/kubelet/config.yaml

cat /var/lib/kubelet/config.yaml
staticPodPath: /etc/kubernetes/manifests # 20s扫描一次，加载static Pods

ls /etc/kubernetes/manifests
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

ks get po -o=name
pod/etcd-wsl-ubuntu20.04
pod/kube-apiserver-wsl-ubuntu20.04
pod/kube-controller-manager-wsl-ubuntu20.04
pod/kube-proxy-6cxcz
pod/kube-scheduler-wsl-ubuntu20.04
``````

