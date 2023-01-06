# Provider
# --------
variable "location" {
  default     = "East US"
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Azure resource group name"
}


# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
  type        = bool
}
