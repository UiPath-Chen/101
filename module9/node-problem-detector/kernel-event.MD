### Download helm chart and unzip
无法从默认镜像仓库下载：registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.14

### 自定义helm chart
```bash
helm install node-problem-detector oci://registry-1.docker.io/dockerkeystone/node-problem-detector --version 2.3.11
```

### 自定义helm chart过程
```sh
helm pull deliveryhero/node-problem-detector
tar -zxvf node-problem-detector-*.tgz
```

### Change image

```sh
vi node-problem-detector/values.yaml
```

```yaml
image:
  # repository: docker.io/dockerkeystone/registry-k8s-io.node-problem-detector.node-problem-detector
  repository: cncamp/node-problem-detector
  tag: v0.8.10
  pullPolicy: IfNotPresent
```

### Install helm chart

```bash
helm install npd ./node-problem-detector
```

```bash
sh -c "echo 'kernel: BUG: unable to handle kernel NULL pointer dereference at TESTING' >> /dev/kmsg"
```

```bash
kubectl describe no
```