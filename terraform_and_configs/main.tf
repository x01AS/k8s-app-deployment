resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.namespace_ingress

  create_namespace = true

  values = [file("${path.module}/helm-value-files/nginx-ingress-values.yaml")]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.namespace_monitoring

  create_namespace = true

  values = [file("${path.module}/helm-value-files/prometheus-values.yaml")]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace_monitoring

  create_namespace = true

  values = [file("${path.module}/helm-value-files/grafana-values.yaml")]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = var.namespace_kube_system

  create_namespace = false

  values = [file("${path.module}/helm-value-files/metrics-server-values.yaml")]
}

resource "kubernetes_config_map" "grafana_dashboards" {
  depends_on = [helm_release.grafana]

  metadata {
    name      = "grafana-dashboards"
    namespace = var.namespace_monitoring
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "k8s-cluster-dashboard.json" = file("${path.module}/dashboards/k8s-cluster-dashboard.json")
    "nginx-ingress-dashboard.json" = file("${path.module}/dashboards/nginx-ingress-dashboard.json")
  }
}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = "docker build -t flask-app:latest ../"
  }
}

resource "null_resource" "kubectl_apply" {
  depends_on = [
    null_resource.docker_build,
    helm_release.nginx_ingress,
    helm_release.prometheus,
    helm_release.grafana,
    helm_release.metrics_server,
    kubernetes_config_map.grafana_dashboards
  ]

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/k8s-manifest/"
  }
}
