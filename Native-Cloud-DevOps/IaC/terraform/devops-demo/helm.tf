provider "helm" {
  kubernetes {
    config_path = local_sensitive_file.kubeconfig.filename # 使用k3s的本地配置文件kubeconfig
  }
}

resource "helm_release" "argo_cd" {
  depends_on       = [module.k3s]               # 显示依赖k3s安装完成
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}
