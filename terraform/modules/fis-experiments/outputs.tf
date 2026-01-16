output "experiment_template_arns" {
  description = "ARNs for the created FIS experiment templates."
  value       = { for name, tpl in aws_fis_experiment_template.this : name => tpl.arn }
}

output "experiment_template_ids" {
  description = "IDs for the created FIS experiment templates."
  value       = { for name, tpl in aws_fis_experiment_template.this : name => tpl.id }
}
