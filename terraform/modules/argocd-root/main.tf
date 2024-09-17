resource "helm_release" "argocd" {
    name = "argocd-root-app"
    namespace = "argocd"
    chart = "${path.root}/../../HelmCharts/argocd-root"

    set {
        name  = "appPath"
        value = var.git_source_path
    }

    set {
        name = "repoUrl"
        value = var.git_source_repo_url
    }

    set {
        name = "targetRevision"
        value = var.git_source_target_revision
    }
}