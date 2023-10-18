### mook big resource request
查看当前node可分配资源状况
```bash
kubectl get no wsl-ubuntu20.04 -o=yaml |yq '.status.allocatable'
```

### 配置
[pod.yaml](pod.yaml)

### 创建
```bash
kubectl create -f pod.yaml
```

### 查看状态
```bash
kubectl describe po resource-beyong-the-node-allocation
```
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  49s   default-scheduler  0/1 nodes are available: 1 Insufficient cpu.