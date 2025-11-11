output "ARM_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.current.subscription_id
}

output "ARM_CLIENT_ID" {
  value = azuread_application.app.client_id
}

output "ARM_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}


output "TF_VAR_RG_NAME" {
    value = azurerm_resource_group.tfstate_remotebackend.name
}

output "TF_VAR_STORAGE_NAME" {
    value = azurerm_storage_account.tfstate.name
}

output "TF_VAR_CONTAINER_NAME" {
  value = azurerm_storage_container.tfstate.name
}

