### Create Jenkins Pod
```bash
kubectl apply -f .
```

### administrator password
```bash
kubectl get po
kubectl logs -f jenkins-0
```
435635a280c8400aa8e6a2168cf9e278

### login
```bash
kubectl get svc
```

http://172.18.27.134:32647

### config k8s

Dashboard -> Manage Jenkins -> Plugin Manager -> 搜索&选择 `kubernetes` -> install without restart

Dashboard -> Manage Jenkins -> Manage Nodes and Clouds -> Configure Clouds