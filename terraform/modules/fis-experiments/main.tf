locals {
  target_name = "EksPodDeleteTarget"
  target = {
    resource_type  = "aws:eks:pod"
    selection_mode = "ALL"
    parameters = {
      clusterIdentifier = var.cluster_identifier
      namespace         = var.namespace
      selectorType      = var.selector_type
      selectorValue     = var.selector_value
    }
  }

  experiments = {
    cpu-stress = {
      description = "Apply CPU pressure to our cluster"
      action = {
        name        = "CPU_STRESS"
        action_id   = "aws:eks:pod-cpu-stress"
        description = "Stress the Pods"
        parameters = {
          duration                = "PT5M"
          kubernetesServiceAccount = var.kubernetes_service_account
        }
        targets     = { Pods = local.target_name }
        start_after = []
      }
      experiment_options = {
        account_targeting           = "single-account"
        empty_target_resolution_mode = "fail"
      }
      tags = { Name = "EKS Stress: CPU Stress" }
    }
    memory-stress = {
      description = "Apply memory stress to our cluster."
      action = {
        name        = "MEMORY_STRESS"
        action_id   = "aws:eks:pod-memory-stress"
        description = "Memory stress on pods"
        parameters = {
          duration                = "PT5M"
          kubernetesServiceAccount = var.kubernetes_service_account
        }
        targets     = { Pods = local.target_name }
        start_after = []
      }
      experiment_options = {
        account_targeting           = "single-account"
        empty_target_resolution_mode = "skip"
      }
      tags = { Name = "EKS Stress: Memory Stress" }
    }
    network-blackhole = {
      description = "Apply network blackholes to commonly used ports."
      action = {
        name        = "NETWORK_BLACKHOLE"
        action_id   = "aws:eks:pod-network-blackhole-port"
        description = "drops traffic for specific ingoing/outgoing to MongoDB"
        parameters = {
          duration                = "PT3M"
          kubernetesServiceAccount = var.kubernetes_service_account
          port                    = "27017"
          protocol                = "tcp"
        }
        targets     = { Pods = local.target_name }
        start_after = []
      }
      experiment_options = {
        account_targeting           = "single-account"
        empty_target_resolution_mode = "skip"
      }
      tags = { Name = "EKS Stress: Network Blackhole" }
    }
    network-latency = {
      description = "Apply network pressure to our cluster."
      action = {
        name        = "NETWORK_LATENCY"
        action_id   = "aws:eks:pod-network-latency"
        description = "causes network latency on cluster"
        parameters = {
          duration                = "PT5M"
          kubernetesServiceAccount = var.kubernetes_service_account
        }
        targets     = { Pods = local.target_name }
        start_after = []
      }
      experiment_options = {
        account_targeting           = "single-account"
        empty_target_resolution_mode = "fail"
      }
      tags = { Name = "EKS Stress: Network Latency" }
    }
    pod-delete = {
      description = "Delete one or more EKS pods, targeting based on cluster and application label"
      action = {
        name        = "EksPodDelete"
        action_id   = "aws:eks:pod-delete"
        parameters = {
          kubernetesServiceAccount = var.kubernetes_service_account
        }
        targets     = { Pods = local.target_name }
        start_after = []
      }
      experiment_options = {
        account_targeting           = "single-account"
        empty_target_resolution_mode = "fail"
      }
      tags = { Name = "EKS Stress: Pod Delete" }
    }
  }
}

resource "aws_fis_experiment_template" "this" {
  for_each    = local.experiments
  description = each.value.description
  role_arn    = var.role_arn

  stop_condition {
    source = "none"
  }

  action {
    name        = each.value.action.name
    action_id   = each.value.action.action_id
    description = try(each.value.action.description, null)
    parameters  = try(each.value.action.parameters, null)
    targets     = each.value.action.targets
    start_after = each.value.action.start_after
  }

  target {
    name           = local.target_name
    resource_type  = local.target.resource_type
    selection_mode = local.target.selection_mode
    parameters     = local.target.parameters
  }

  experiment_options {
    account_targeting           = each.value.experiment_options.account_targeting
    empty_target_resolution_mode = each.value.experiment_options.empty_target_resolution_mode
  }

  log_configuration {
    log_schema_version = 2
    cloudwatch_logs_configuration {
      log_group_arn = var.log_group_arn
    }
  }

  tags = merge(each.value.tags, var.additional_tags)
}
