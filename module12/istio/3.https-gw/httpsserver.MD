### Deploy httpserver

```sh
kubectl create ns securesvc
kubectl label ns securesvc istio-injection=enabled
kubectl -n securesvc create -f httpserver.yaml
```

```sh
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=cncamp Inc./CN=*.cncamp.io' -keyout cncamp.io.key -out cncamp.io.crt
kubectl create -n istio-system secret tls cncamp-credential --key=cncamp.io.key --cert=cncamp.io.crt

kubectl -n securesvc apply -f istio-specs.yaml
```

### Check ingress ip

```sh
k get svc -nistio-system

istio-ingressgateway   LoadBalancer   $INGRESS_IP
```

### Access the httpserver via ingress

```sh
curl --resolve httpsserver.cncamp.io:443:$INGRESS_IP https://httpsserver.cncamp.io/healthz -v -k
```
