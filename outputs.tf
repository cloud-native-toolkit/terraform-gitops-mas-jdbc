
output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [gitops_module.jdbcmodule]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [gitops_module.jdbcmodule]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = local.namespace
  depends_on  = [gitops_module.jdbcmodule]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [gitops_module.jdbcmodule]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [gitops_module.jdbcmodule]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [gitops_module.jdbcmodule]
}

output "config_name" {
  description = "The jdbc confirg name deployed"
  value       = local.jdbc_name
  depends_on  = [gitops_module.jdbcmodule]
}

output "jdbc_secret_name" {
  description = "The secret with the jdbc credentials"
  value       = local.db_secret_name
  depends_on  = [gitops_module.jdbcmodule]
}

output "scope" {
  description = "scope for the jdbc connection"
  value = var.scope
  depends_on = [gitops_module.jdbcmodule]
}
