### ipvsadm
```bash
apt install -y ipvsadm
ipvsadm -L -n
```

### 切换kube-proxy工作模式
```bash
kubectl -n kube-system get configmap
kubectl -n kube-system get configmap kube-proxy

kubectl -n kube-system edit configmap kube-proxy
# set mode: "ipvs"

kubectl -n kube-system get po
kubectl -n kube-system delete po kube-proxy-wmp5n
iptables -F
ipvsadm -L -n
```