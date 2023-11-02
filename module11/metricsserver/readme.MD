
### 原理
```sh
kubectl get --raw "/api/v1/nodes/node1/proxy/metrics/resource"
```

### apiresources
```bash
kubectl get apiservice
kubectl get apiservice v1beta1.metrics.k8s.io -o=yaml
```

### 查看负载
```bash
kubectl top no/node
kubectl top pod
kubectl top pod [-v 9]
```