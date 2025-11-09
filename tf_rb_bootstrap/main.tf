resource "azurerm_resource_group" "tfstate_remotebackend" {
  name     = var.azure_resource_group
  location = var.azure_location
}

resource "random_string" "generated" {
  length  = 10
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "${var.azure_storage_account}${random_string.generated.result}"
  resource_group_name             = azurerm_resource_group.tfstate_remotebackend.name
  location                        = azurerm_resource_group.tfstate_remotebackend.location
  account_tier                    = var.azure_storage_account_tier
  account_replication_type        = var.azure_storage_account_replication
  allow_nested_items_to_be_public = false
  depends_on                      = [azurerm_resource_group.tfstate_remotebackend]
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.azure_storage_container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = var.azure_storage_container_access_type
  depends_on            = [azurerm_storage_account.tfstate]
} 