resource "azurecaf_name" "resource_group" {
  name          = var.base_name
  resource_type = "azurerm_resource_group"
  suffixes      = ["prod"]
}

resource "azurerm_resource_group" "webapp" {
  name       = azurecaf_name.resource_group.result
  location   = var.azure_location
  depends_on = [azurecaf_name.resource_group]
}