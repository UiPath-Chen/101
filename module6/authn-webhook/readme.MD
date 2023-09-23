### Start authservice

```sh
make build
./bin/amd64/authn-webhook
```

### Create webhook config
> 如果想让apiserver跟webhook做集成，必须让apiserver知道我有一个webhook要运行；所以需要给apiserver做一些配置
```sh
mkdir -p /etc/config
cp webhook-config.json /etc/config
```

### Backup old apiserver

```sh
cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml
```

### Update apiserver configuration to enable webhook

```sh
cp specs/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

# 验证apiserver这个Pod是否重启了
kubectl get po
```

## 验证
### Create a personal access token in github and put your github personal access token to kubeconfig
> settings -> Developer setting -> Personal access tokens -> Fine-grained tokens -> Generate new token -> Token name: k8suser; Expiration: 7 days -> Generate token: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

```sh
nano ~/.kube/config
```

```yaml
users:
...
- name: mfanjie
  user:
    token: <mytoken>
```

### Get pods by mfanjie

```sh
kubectl get po --user mfanjie
```

### Reset the env

```sh
cp ~/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
```
