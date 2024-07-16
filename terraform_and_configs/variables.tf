variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace_ingress" {
  description = "Namespace for Nginx Ingress"
  type        = string
  default     = "ingress-nginx"
}

variable "namespace_monitoring" {
  description = "Namespace for monitoring tools"
  type        = string
  default     = "monitoring"
}

variable "namespace_kube_system" {
  description = "Namespace for Kubernetes system components"
  type        = string
  default     = "kube-system"
}