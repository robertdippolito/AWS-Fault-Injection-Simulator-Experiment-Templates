output "experiment_template_arns" {
  description = "ARNs for the created FIS experiment templates."
  value       = module.fis_experiments.experiment_template_arns
}

output "experiment_template_ids" {
  description = "IDs for the created FIS experiment templates."
  value       = module.fis_experiments.experiment_template_ids
}
