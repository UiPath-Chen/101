```sh
kubectl create -f php-apache.yaml
kubectl create -f hpav2.yaml

# 压力测试
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

# 监控pods资源变化
watch kubectl top pods
```
