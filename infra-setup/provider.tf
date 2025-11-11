terraform {
  backend "azurerm" {
    use_oidc = true
  }
  required_version = ">= 1.13.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}