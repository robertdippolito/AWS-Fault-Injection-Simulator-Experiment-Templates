variable "role_arn" {
  type        = string
  description = "IAM role ARN assumed by AWS FIS to run the experiments."
}

variable "log_group_arn" {
  type        = string
  description = "CloudWatch log group ARN for experiment logs."
}

variable "cluster_identifier" {
  type        = string
  description = "EKS cluster identifier used by the FIS target selector."
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for the pod selector."
  default     = "api"
}

variable "selector_type" {
  type        = string
  description = "Selector type used to match pods."
  default     = "labelSelector"
}

variable "selector_value" {
  type        = string
  description = "Selector value used to match pods."
  default     = "app=k8s-api"
}

variable "kubernetes_service_account" {
  type        = string
  description = "Kubernetes service account used by FIS actions."
  default     = "fis-sa"
}

variable "additional_tags" {
  type        = map(string)
  description = "Extra tags to apply to all experiment templates."
  default     = {}
}
