terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "fis_experiments" {
  source = "./modules/fis-experiments"

  role_arn                   = var.role_arn
  log_group_arn              = var.log_group_arn
  cluster_identifier         = var.cluster_identifier
  namespace                  = var.namespace
  selector_type              = var.selector_type
  selector_value             = var.selector_value
  kubernetes_service_account = var.kubernetes_service_account
  additional_tags            = var.additional_tags
}
