data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}

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

resource "azuread_application" "app" {
  display_name = var.azure_app_name
}

resource "azuread_service_principal" "sp" {
  client_id  = azuread_application.app.client_id
  depends_on = [azuread_application.app]
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_role_assignment" "storage_access" {
  scope                = azurerm_storage_container.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azuread_application_federated_identity_credential" "fd_env" {
  application_id = azuread_application.app.id
  display_name   = "${var.fd_credential_name}-env"
  audiences      = var.gh_audiences
  issuer         = var.gh_issuer
  subject        = "repo:${var.gh_owner}/${var.gh_repository}:environment:${var.gh_environment}"
}

resource "azuread_application_federated_identity_credential" "fd_pull" {
  application_id = azuread_application.app.id
  display_name   = "${var.fd_credential_name}-pull"
  audiences      = var.gh_audiences
  issuer         = var.gh_issuer
  subject        = "repo:${var.gh_owner}/${var.gh_repository}:pull_request"
}


