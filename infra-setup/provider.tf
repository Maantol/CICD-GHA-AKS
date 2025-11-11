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
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}


provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azurecaf" {}