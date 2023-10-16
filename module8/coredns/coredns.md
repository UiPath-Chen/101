```yaml
spec:
  containers:
    containers:
    - image: nginx
      imagePullPolicy: Always
  dnsPolicy: ClusterFirst
```
默认Pod的dnsPolicy是ClusterFirst

```bash
kubectl exec -it po nginx-deployment-7848d4b86f-wrv27 -- cat /etc/resolv.conf
```
nameserver 10.96.0.10                                    # 域名服务器
search default.svc.cluster.local svc.cluster.local cluster.local # 短名域名
options ndots:5                                                  # 定义什么是短名，定义dot数量

### dns服务
```bash
kubectl -n kube-system get svc
```
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   20h

```bash
# 2个coredns，就是域名服务器，和其controller，分别负责记录DNS和向DNS刷DNS记录
kubectl -n kube-system get po
```
coredns-7f6cbbb7b8-lczjp                  1/1     Running   3 (40m ago)    20h
coredns-7f6cbbb7b8-xktng                  1/1     Running   3 (40m ago)    20h

### 访问域名
```bash
kubectl exec -i -t -n default nginx-deployment-7848d4b86f-gxgfl -c nginx -- sh -c "clear; (bash || ash || sh)"
curl -v nginx-basic.default.svc.cluster.local
```

### env
```yml
  spec:
    containers:
    - image: nginx
      imagePullPolicy: Always
    enableServiceLinks: true
```
```bash
# pod启动后，可以通过ENV查看已存在的服务, 这些服务都是以环境变量的形式存在；
# 但当service大量存在，再启动Pod，进程要启动非常长的参数，导致参数长度限制，导致进程启动失败
kubectl exec -i -t -n default nginx-deployment-7848d4b86f-gxgfl -c nginx -- sh -c "clear; (bash || ash || sh)"
env
```