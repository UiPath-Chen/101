### 创建emptyDir
```bash
cat emptydir.yaml | k apply -f -
``````

### 进入容器查看
```bash
kubectl exec -i -t -n default nginx-deployment-758b46c78b-rqcf6 -c nginx -- sh -c "clear; (bash || ash || sh)"
``````


