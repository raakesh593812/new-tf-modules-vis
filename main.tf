# -----------------------------------------------------------------------------
# Azure resource groups
# -----------------------------------------------------------------------------
module "resource_groups" {
  source = "./modules/resource_groups"
  location             = "eastus" #var.location
  resource_group_name     = "vis-rg-test" #var.resource_group_name
  create_resource_group = true
 tags = var.tags
}
# Azure postgres
# -----------------------------------------------------------------------------
module "database" {
  source = "./modules/database"
  resource_group_name   = module.resource_groups.resource_group_name
  location              = module.resource_groups.resource_group_location

  # PostgreSQL Server and Database settings
  postgresql_server_name = "mypostgresdbsrv01"

  postgresql_server_settings = {
    sku_name   = "GP_Gen5_8"
    storage_mb = 640000
    version    = "9.6"
    # default admin user `postgresadmin` and can be specified as per the choice here
    # by default random password created by this module. required password can be specified here
    admin_username = "postgresadmin"
    admin_password = "H@Sh1CoR3!"
    # Database name, charset and collection arguments  
    database_name = "demo-postgres-db"
    charset       = "UTF8"
    collation     = "English_United States.1252"
    # Storage Profile and other optional arguments
    auto_grow_enabled                = true
    backup_retention_days            = 7
    geo_redundant_backup_enabled     = true
    public_network_access_enabled    = true
    ssl_enforcement_enabled          = true
    ssl_minimal_tls_version_enforced = "TLS1_2"
  }

}