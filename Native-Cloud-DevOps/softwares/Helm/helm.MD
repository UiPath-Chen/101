### 官网
https://helm.sh/

Helm installs *charts* into Kubernetes, creating a new *release* for each installation. And to find new charts, you can search Helm chart *repositories*.

### Helm Charts repository
---
https://artifacthub.io/

### 原理
一套模板工具-helm template，使用values，对模板进行渲染，渲染出真正的Manifest
动态Manifest
应用源代码 -> Dockerfile -> image -> helm wrap manifest

### 安装
---
```bash
snap install helm --classic
```

### 操作
https://helm.sh/docs/intro/quickstart/

```bash
helm repo add <repo-name> <url>   # Add a repository from the internet:
helm repo update                  # Update information of available charts locally from chart repositories
```

### helm list
release 实例，会创建secrets - sh.helm.release.v1.ingress-nginx.v1

## 应用
* 新建一套环境
1. git中的业务代码中，新建一个分支，命名b1
2. 在git中的Application Definition仓库，charts > env > 新建b1目录 > values.yaml

* 根据release反推出helm
无法
但可以根据release，查看一些信息
```bash
helm get all <release>      # A human readable collection of information about the notes, hooks, supplied values, and generated manifest file of the given release.

helm get manifest <release> # A manifest is a YAML-encoded representation of the Kubernetes resources that were generated from this release's chart(s). If a chart is dependent on other charts, those resources will also be included in the manifest.

helm get values <release>   # Downloads a values file for a given release. use -o to format output
```

*

### 学习资料
https://github.com/bitnami/charts