output "ARM_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.current.subscription_id
}

output "ARM_CLIENT_ID" {
  value = azuread_application.app.client_id
}

output "ARM_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}