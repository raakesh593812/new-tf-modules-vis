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
# # Azure postgres
# # -----------------------------------------------------------------------------
# module "database" {
#   source = "./modules/database"
#   resource_group_name   = module.resource_groups.resource_group_name
#   location              = module.resource_groups.resource_group_location

#   # PostgreSQL Server and Database settings
#   postgresql_server_name = "mypostgresdbsrv01"

#   postgresql_server_settings = {
#     sku_name   = "GP_Gen5_8"
#     storage_mb = 640000
#     version    = "9.6"
#     # default admin user `postgresadmin` and can be specified as per the choice here
#     # by default random password created by this module. required password can be specified here
#     admin_username = "postgresadmin"
#     admin_password = "H@Sh1CoR3!"
#     # Database name, charset and collection arguments  
#     database_name = "demo-postgres-db"
#     charset       = "UTF8"
#     collation     = "English_United States.1252"
#     # Storage Profile and other optional arguments
#     auto_grow_enabled                = true
#     backup_retention_days            = 7
#     geo_redundant_backup_enabled     = true
#     public_network_access_enabled    = true
#     ssl_enforcement_enabled          = true
#     ssl_minimal_tls_version_enforced = "TLS1_2"
#   }

# }

# module "Keyvault" {
#   source = "./modules/Keyvault"
#   resource_group_name        = module.resource_groups.resource_group_name
#   location                   = module.resource_groups.resource_group_location
#   key_vault_name             = "xdeasdkgshard"
#   key_vault_sku_pricing_tier = "premium"
#   enable_purge_protection = false
#   secrets = {
#     "message" = "Hello, world!"
#     "vmpass"  = "excc"
#   }
#   tags = {
#     ProjectName  = "demo-project"
#     Env          = "dev"
#     Owner        = "user@example.com"
#     BusinessUnit = "CORP"
#     ServiceClass = "Gold"
#   }
# }

# module "storage" {
#   source  = "./modules/storageaccount"

#   resource_group_name   = module.resource_groups.resource_group_name
#   location              = module.resource_groups.resource_group_location
#   storage_account_name  = "zmystoragew1x"
#   enable_advanced_threat_protection = true

#   # Container lists 
#   containers_list = [
#     { name = "mystore250", access_type = "private" },
#     { name = "blobstore251", access_type = "blob" },
#     { name = "containter252", access_type = "container" }
#   ]

#   # Storage queues
#   #queues = ["queue1", "queue2"]
#   enable_adls =  false
#   # Configure managed identities to access Azure Storage (Optional)
#   # Possible types are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
#   managed_identity_type = "SystemAssigned"
#   #managed_identity_ids  = [for k in azurerm_user_assigned_identity.example : k.id]

#   # Lifecycle management for storage account.
#   # Must specify the value to each argument and default is `0` 
#   lifecycles =   [{
#       prefix_match               = ["mystore250/folder_path"]
#       tier_to_cool_after_days    = 0
#       tier_to_archive_after_days = 50
#       delete_after_days          = 100
#       snapshot_delete_after_days = 30
#     },
#     {
#       prefix_match               = ["blobstore251/another_path"]
#       tier_to_cool_after_days    = 0
#       tier_to_archive_after_days = 30
#       delete_after_days          = 75
#       snapshot_delete_after_days = 30
#     }]

#   # Adding TAG's to your Azure resources (Required)
#   # ProjectName and Env are already declared above, to use them here, create a varible. 
#   tags = {
#     ProjectName  = "demo-internal"
#     Env          = "dev"
#     Owner        = "user@example.com"
#     BusinessUnit = "CORP"
#     ServiceClass = "Gold"
#   }
# }
