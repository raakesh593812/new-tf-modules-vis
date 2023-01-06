resource "random_password" "main" {
  count       = var.admin_password == null ? 1 : 0
  length      = var.random_password_length
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false

  keepers = {
    administrator_login_password = var.postgresql_server_name
  }
}


resource "azurerm_postgresql_server" "main" {
  name                              = format("%s", var.postgresql_server_name)
  resource_group_name               = var.resource_group_name
  location                          = var.location
  administrator_login               = var.admin_username == null ? "postgresadmin" : var.admin_username
  administrator_login_password      = var.admin_password == null ? random_password.main.0.result : var.admin_password
  sku_name                          = var.postgresql_server_settings.sku_name
  version                           = var.postgresql_server_settings.version
  storage_mb                        = var.postgresql_server_settings.storage_mb
  auto_grow_enabled                 = var.postgresql_server_settings.auto_grow_enabled
  backup_retention_days             = var.postgresql_server_settings.backup_retention_days
  geo_redundant_backup_enabled      = var.postgresql_server_settings.geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.postgresql_server_settings.infrastructure_encryption_enabled
  public_network_access_enabled     = var.postgresql_server_settings.public_network_access_enabled
  ssl_enforcement_enabled           = var.postgresql_server_settings.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced  = var.postgresql_server_settings.ssl_minimal_tls_version_enforced
  create_mode                       = var.create_mode
  creation_source_server_id         = var.create_mode != "Default" ? var.creation_source_server_id : null
  restore_point_in_time             = var.create_mode == "PointInTimeRestore" ? var.restore_point_in_time : null
  tags                              = merge({ "Name" = format("%s", var.postgresql_server_name) }, var.tags, )

  dynamic "identity" {
    for_each = var.identity == true ? [1] : [0]
    content {
      type = "SystemAssigned"
    }
  }


}


#------------------------------------------------------------
# Adding  PostgreSQL Server Database - Default is "true"
#------------------------------------------------------------
resource "azurerm_postgresql_database" "main" {
  name                = var.postgresql_server_settings.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  charset             = var.postgresql_server_settings.charset
  collation           = var.postgresql_server_settings.collation
}

#------------------------------------------------------------
# Adding  PostgreSQL Server Parameters - Default is "false"
#------------------------------------------------------------
resource "azurerm_postgresql_configuration" "main" {
  for_each            = var.postgresql_configuration != null ? { for k, v in var.postgresql_configuration : k => v if v != null } : {}
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  value               = each.value
}
