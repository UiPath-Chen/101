## Prepare
### Create cvm
```
ssh-copy-id ubuntu@101.32.194.253
ssh 'ubuntu@101.32.194.253'
```

### Install kind
```bash
KINDPATH=/usr/local/bin/kind
curl -Lo $KINDPATH https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod o+x $KINDPATH
kind --version
```

### Install docker
### Install kubectl
```bash
snap install kubectl --classic
kubectl version --client
```
### Install clusterctl
```bash
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.1.3/clusterctl-linux-amd64 -o /usr/local/bin/clusterctl && chmod +x /usr/local/bin/clusterctl

clusterctl version
```


## Create host cluster

```sh
./create_cluster.sh
```

### Generate cluster specs

```sh
cd cluster-api
./init_docker_provider.sh
./generate_workload_cluster.sh
kubectl apply -f capi-quickstart.yaml
```

### verify
```bash
kubectl get no
```

### Check

```sh
docker ps|grep control-plane

b107b11771e5        kindest/haproxy:v20210715-a6da3463   "haproxy -sf 7 -W -d…"   4 minutes ago       Up 4 minutes        40295/tcp, 0.0.0.0:40295->6443/tcp     capi-quickstart-lb
clusterctl get kubeconfig capi-quickstart > capi-quickstart.kubeconfig
kubectl get no --kubeconfig capi-quickstart.kubeconfig --server https://127.0.0.1:40295
NAME                                    STATUS     ROLES                  AGE     VERSION
capi-quickstart-control-plane-6slwd     NotReady   control-plane,master   4m19s   v1.22.0
capi-quickstart-md-0-765cf784c5-6klwr   NotReady   <none>                 3m41s   v1.22.0
```

```sh
kubectl get cluster
kubectl get machineset
```
