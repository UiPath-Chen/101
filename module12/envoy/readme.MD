### Deploy simple

```sh
kubectl create -f simple.yaml
```

### Deploy envoy

```sh
kubectl create configmap 'envoy-config' --from-file=envoy.yaml
kubectl create -f envoy-deploy.yaml
```

### test
```bash
kubectl get svc
kubectl get cm
kubectl get po -o=yaml
curl ip:10000/hello
```