output "nginx_ingress_status" {
  value = helm_release.nginx_ingress.status
}

output "prometheus_status" {
  value = helm_release.prometheus.status
}

output "grafana_status" {
  value = helm_release.grafana.status
}

output "metrics_server_status" {
  value = helm_release.metrics_server.status
}