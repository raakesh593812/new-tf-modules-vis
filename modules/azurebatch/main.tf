resource "azurerm_resource_group" "this" {
  name     = "rg-batchservice"
  location = "eastus"
}


resource "azurerm_batch_account" "this" {
  name                 = "batchazvispocx"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  pool_allocation_mode = "BatchService"
  storage_account_authentication_mode = "StorageKeys"
  storage_account_id   = "/subscriptions/23691e30-29e0-45f0-9efa-9e38d2d8358e/resourceGroups/cloud-shell-storage-centralindia/providers/Microsoft.Storage/storageAccounts/csg100300009f52f5f3"
}

resource "azurerm_batch_pool" "this" {
  name                = "pool0"
  resource_group_name = azurerm_resource_group.this.name
  account_name        = azurerm_batch_account.this.name
  display_name        = "Auto-Scale Pool"
  vm_size             = "Standard_A1"
  node_agent_sku_id   = "batch.node.ubuntu 20.04"

  auto_scale {
    evaluation_interval = "PT5M"

    formula = <<EOF
      startingNumberOfVMs = 1;
      maxNumberofVMs = 25;
      pendingTaskSamplePercent = $PendingTasks.GetSamplePercent(180 * TimeInterval_Second);
      pendingTaskSamples = pendingTaskSamplePercent < 70 ? startingNumberOfVMs : avg($PendingTasks.GetSample(180 *   TimeInterval_Second));
      $TargetDedicatedNodes=min(maxNumberofVMs, pendingTaskSamples);
EOF
  }

  storage_image_reference {
    publisher = "microsoft-azure-batch"
    offer     = "ubuntu-server-container"
    sku       = "20-04-lts"
    version   = "latest"
  }

  start_task {
    command_line         = "/bin/bash -c 'wget https://bootstrap.pypa.io/get-pip.py && chmod +x get-pip.py && python3 get-pip.py && pip install azure-storage-blob pandas'"
    task_retry_maximum = 1
    wait_for_success     = true

    user_identity {
      auto_user {
        elevation_level = "NonAdmin"
        scope           = "Task"
      }
    }
  }
}
