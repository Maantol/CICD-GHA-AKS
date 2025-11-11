variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_location" {
  description = "Azure Region"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure Resource Group name"
  type        = string
}

variable "azure_storage_account" {
  description = "Azure Storage Account name"
  type        = string
  default     = "tfstate"
}

variable "azure_storage_account_tier" {
  description = "Azure Storage Account tier"
  type        = string
  default     = "Standard"
}

variable "azure_storage_account_replication" {
  description = "Azure Storage Account replication type"
  type        = string
  default     = "LRS"
}

variable "azure_storage_container_name" {
  description = "Azure Storage Container name"
  type        = string
  default     = "tfstate"
}

variable "azure_storage_container_access_type" {
  description = "Azure Storage Container access type"
  type        = string
  default     = "private"
}

variable "azure_app_name" {
  description = "Azure App Registration Display Name"
  type        = string
}

variable "fd_credential_name" {
  description = "Federated Credential name"
  type        = string
}

variable "gh_owner" {
  description = "GitHub Owner/Organization name"
  type        = string
}

variable "gh_repository" {
  description = "GitHub Repository name"
  type        = string
}

variable "gh_environment" {
  description = "GitHub Environment"
  type        = string
  default     = "production"
}

variable "gh_issuer" {
  description = "GitHub Issuer URL"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "gh_audiences" {
  description = "AzureAD Audiences API"
  type        = list(string)
  default     = ["api://AzureADTokenExchange"]
}