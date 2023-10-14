### hub.docker.io
https://helm.sh/docs/topics/registries/
https://docs.docker.com/docker-hub/oci-artifacts/
```bash
helm pull deliveryhero/node-problem-detector
tar -zxvf node-problem-detector-*.tgz
nano node-problem-detector/values.yaml
# image:
#   # repository: docker.io/dockerkeystone/registry-k8s-io.node-problem-detector.node-problem-detector
#   repository: cncamp/node-problem-detector
#   tag: v0.8.10
#   pullPolicy: IfNotPresent
# helm install node-problem-detector ./node-problem-detector

echo $token |helm registry login registry-1.docker.io -u dockerkeystone --password-stdin
helm package node-problem-detector --version 2.3.11
helm push node-problem-detector-2.3.11.tgz oci://registry-1.docker.io/dockerkeystone

# 登录hub.docker.io, 进入node-problem-detector仓库，点击tag
```
