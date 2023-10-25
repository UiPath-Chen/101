### Evict all pods from a node

```bash
kubectl apply -f nginx-deployment.yaml
kubectl get po

kubectl apply -f pdb.yaml
kubectl get pdb
```

```sh
kubectl drain <nodeName> [--force]
```

### Make a node scheduable again

```sh
kubectl cordon NODE
kubectl uncordon NODE
```

```sh
cat ~/.kube/config |yq '.users[0].user.client-certificate-data' |base64 -d >admin.crt
cat ~/.kube/config |yq '.users[0].user.client-key-data'         |base64 -d >admin.key
```

```bash
kubectl get po
```


修改命令行和eviction.json文件中的podName，然后进行驱逐，结果Eviction Success
-k, --insecure
```bash
curl -v -H 'Content-type: application/json' \
-k \
--key admin.key \
--cert admin.crt \
https://172.19.0.14:6443/api/v1/namespaces/default/pods/nginx-deployment-6799fc88d8-48j6s/eviction \
-d @eviction.json
```

修改minAvailable由1变成3
```bash
kubectl edit pdb
```

重复调用Evition API, 结果Failure
 "message": "The disruption budget nginx-deployment needs 3 healthy pods and has 3 currently"

