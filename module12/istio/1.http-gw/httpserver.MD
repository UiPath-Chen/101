### Deploy simple

```sh
kubectl create ns simple
kubectl create -f simple.yaml -n simple
kubectl create -f istio-specs.yaml -n simple
```

### Check ingress ip

```sh
k get svc -n istio-system

istio-ingressgateway   LoadBalancer   10.108.31.242
```

### Access the simple via ingress

```sh
export INGRESS_IP=10.108.31.242
curl -H "Host: simple.cncamp.io" $INGRESS_IP/hello [-v]
```


### test
```bash
kubectl -n simple get po
kubectl -n simple get svc
kubectl -n simple get vs
kubectl -n simple get gw
```

### 查看Envoy配置
```bash
kubectl exec -it istio-ingressgateway-xxx-yy -n istio-system -- bash
curl localhost:15000/config_dump
```

###