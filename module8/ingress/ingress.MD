### Install ingress controller
https://blog.csdn.net/weixin_43988498/article/details/122792536
```sh
kubectl create -f nginx-ingress-deployment.yaml
```

### Generate key-cert

```sh
# use openssl (version >= 1.1.1f) on Linux, e.g. Ubuntu 20.04
# don't run on macOS, which is using LibreSSL
# instead, you can `brew install openssl` on macOS
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=cncamp.com/O=cncamp" -addext "subjectAltName = DNS:cncamp.com"
```

### Create secret

```sh
kubectl create secret tls cncamp-tls --cert=./tls.crt --key=./tls.key
```

### Create a ingress

```sh
kubectl create -f ingress.yaml
```
debug
```bash
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```

### Test the result
通过ingress的service IP
```sh
kubectl -n ingress-nginx get svc
# NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
# ingress-nginx-controller             NodePort    10.110.64.134    <none>        80:30779/TCP,443:30530/TCP   29m


curl -H "Host: cncamp.com" https://10.109.204.181 -v -k
```

### Understand why ingress is not enough?
以下不支持：
- tls: cypher版本, dhkey, TLSVersion
- header based L7 rule 基于header
- rewriting?        重写？
  - header rewriting
  - URI rewriting

### How rewrite is supported in nginx ingress
通过一些annotation所支持的其他功能
```
Name	Description	Values
nginx.ingress.kubernetes.io/rewrite-target	Target URI where the traffic must be redirected	string
nginx.ingress.kubernetes.io/ssl-redirect	Indicates if the location section is accessible SSL only (defaults to True when Ingress contains a Certificate)	bool
nginx.ingress.kubernetes.io/force-ssl-redirect	Forces the redirection to HTTPS even if the Ingress is not TLS Enabled	bool
nginx.ingress.kubernetes.io/app-root	Defines the Application Root that the Controller must redirect if it's in '/' context	string
nginx.ingress.kubernetes.io/use-regex	Indicates if the paths defined on an Ingress use regular expressions	bool
```


### ingress无法解决生成问题
- ingress太简单了，无法解决大量复杂的生成问题
- counter： http proxy方案
- istio