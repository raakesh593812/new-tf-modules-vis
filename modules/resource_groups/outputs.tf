output "resource_group_name" {
  value       = local.resource_group_name
  description = "The name of the resource group into which to provision all resources"
}

output "resource_group_location" {
  value       = local.location
  description = "The location  of the resource group into which to provision all resources"
}
