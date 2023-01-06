locals {

  resource_group_name      = element(coalescelist(data.azurerm_resource_group.resource_group.*.name, azurerm_resource_group.resource_group.*.name, [""]), 0)
  location                 = element(coalescelist(data.azurerm_resource_group.resource_group.*.location, azurerm_resource_group.resource_group.*.location, [""]), 0)
}


data "azurerm_resource_group" "resource_group" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}