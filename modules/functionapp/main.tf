# Required Providers
# ------------------
# https://registry.terraform.io/providers/hashicorp/azurerm/latest
terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2"
    }

  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = "functionapp"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "winxyfunxzappsa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                = "fn-app-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Windows"
  sku_name            = "Y1"
}
resource "azurerm_application_insights" "application_insights" {
  name                = "functionapp-application-insights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}
resource "azurerm_windows_function_app" "example" {
  name                = "prapsgithub"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  app_settings = {
        https_only = true
        FUNCTIONS_WORKER_RUNTIME = "powershell"
        FUNCTIONS_WORKER_RUNTIME_VERSION = "~7"
        WEBSITE_NODE_DEFAULT_VERSION = "~10"
        APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.application_insights.instrumentation_key
         }

  site_config {}
}
