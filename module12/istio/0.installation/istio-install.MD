### Install istio
https://istio.io/


```sh
curl -L https://istio.io/downloadIstio | sh -

nano /etc/profile
# export PATH="$PATH:/root/istio-1.19.3/bin"

istioctl x precheck # 可忽略

cd istio-1.12.0
cp bin/istioctl /usr/local/bin
istioctl install --set profile=demo -y
```

### test
```bash
kubectl get po -n istio-system
```

### Istio monitoring

- Grafana dashboard `7639`
