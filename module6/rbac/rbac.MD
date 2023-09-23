### 续接authn-webhook
```bash
kubectl get po --user myuser1
``````

> Error from server (Forbidden): pods is forbidden: User "UiPath-Chen" cannot list resource "pods" in API group "" in the namespace "default"


# 创建rolebindings
> 使用内置的role: cluster-admin, 超级role
```bash
kubectl get clusterroles cluster-admin -o=yaml
cat cluster-admin-to-mfanjie.yaml |kubectl apply -f -
``````