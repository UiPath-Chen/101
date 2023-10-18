### 使用场景
- GPU: device manager

### 默认资源维度
```bash
kubectl get no <nodename>
```

```yml
status:
  allocatable:
    cpu: "2"
    ephemeral-storage: "972991057538"
    hugepages-1Gi: "0"
    hugepages-2Mi: "0"
    memory: 5971128Ki
    pods: "110"
  capacity:
    cpu: "2"
    ephemeral-storage: 1055762868Ki
    hugepages-1Gi: "0"
    hugepages-2Mi: "0"
    memory: 6073528Ki
    pods: "110"
```

### 添加额外的资源维度 - curl patch

首先提取certificate、key数据
```bash
yq '.users[0].user.client-certificate-data' ~/.kube/config |base64 -d > admin.crt
yq '.users[0].user.client-key-data'         ~/.kube/config |base64 -d > admin.key
```

```sh
curl \
--key admin.key \
--cert admin.crt \
--header "Content-Type: application/json-patch+json" \
--request PATCH \
# --insecure 跳过安全检测
-k \
# --data
-d '[{"op": "add", "path": "/status/capacity/cncamp.com~1reclaimed-cpu", "value": "2"}]' \
https://172.18.27.134:6443/api/v1/nodes/<nodename>/status
```
nodename: wsl-ubuntu20.04

```bash
kubectl get no <nodename>
```

```yml
status
  capacity:
    cncamp.com/reclaimed-cpu: "2"    # 多了额外资源配置 2cpu
    cpu: "2"
    ephemeral-storage: 1055762868Ki
    hugepages-1Gi: "0"
    hugepages-2Mi: "0"
    memory: 6073528Ki
    pods: "110"
```

### 使用资源
```bash
# 3cpu
kubectl apply -f deployment.yaml
kubectl describe $(kubectl get po -o NAME |grep nginx-deployment)
# 3->2
nano deployment.yaml
kubectl apply -f deployment.yaml
# scale up 创建多余pod，失败
kubectl scale deployment nginx-deployment --replicas=2
```

### 扩展资源使用总结
- 只能时整数
- 无法超售，requests === limits
- 无法驱逐，自己维护逻辑

