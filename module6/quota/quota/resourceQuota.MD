### 创建configMap, 现在还可以创建
```bash
cat game-config.yaml |kubectl create -f -

kubectl get cm

cat game-config.yaml |kubectl delete -f -
``````

### 创建quota
```bash
cat quota.yaml |kubectl create -f -

kubectl get quota object-counts -o=yaml
``````
```yml
apiVersion: v1
kind: ResourceQuota
metadata:
  creationTimestamp: "2023-09-23T03:10:45Z"
  name: object-counts
  namespace: default
  resourceVersion: "138226"
  uid: 3c0f1dfe-5d2b-4a48-9e88-1b78223522dc
spec:
  hard:
    configmaps: "1"
status:
  hard:
    configmaps: "1"  # 配额1
  used:
    configmaps: "1"  # 当前使用1
``````

### 新增cm
```bash
cat game-config.yaml |kubectl create -f -
``````
> Error from server (Forbidden): error when creating "STDIN": configmaps "game-config" is forbidden: exceeded quota: object-counts, requested: configmaps=1, used: configmaps=1, limited: configmaps=1