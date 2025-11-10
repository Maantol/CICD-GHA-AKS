terraform {
  backend "azurerm" {
    resource_group_name = "tfstate_remotebackend"
    storage_account_name = "tfstate0m9apovthi"
    container_name = "tfstate"
    key = "terraform-infra.tfstate"
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
}