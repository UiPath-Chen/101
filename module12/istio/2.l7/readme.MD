### 部署多套服务
https://blog.csdn.net/weixin_41709748/article/details/122552765
https://blog.csdn.net/WuYuChen20/article/details/105932193/

```sh
kubectl apply -f nginx.yaml -n simple
kubectl apply -f istio-specs.yaml -n simple
```


### Test
```bash
kubectl get po,svc -n simple
export INGRESS_IP=10.108.31.242
curl -H "Host: simple.cncamp.io" $INGRESS_IP/simple/hello
curl -H "Host: simple.cncamp.io" $INGRESS_IP/nginx
```