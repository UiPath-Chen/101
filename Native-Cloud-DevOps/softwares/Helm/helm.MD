### 官网
https://helm.sh/

Helm installs *charts* into Kubernetes, creating a new *release* for each installation. And to find new charts, you can search Helm chart *repositories*.

### Helm Charts repository
---
https://artifacthub.io/

### 原理
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

## 应用
1. 新建一套环境
- 1. git中的业务代码中，新建一个分支，命名b1
- 2. 在git中的Application Definition仓库，charts > env > 新建b1目录 > values.yaml


### 学习资料
https://github.com/bitnami/charts