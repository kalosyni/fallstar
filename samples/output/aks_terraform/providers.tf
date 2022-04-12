terraform {
  required_providers {
    # https://github.com/hashicorp/terraform-provider-azurerm
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.66.0"
    }
  }

  required_version = ">= 0.14"

  # https://www.terraform.io/language/settings/backends/local
  backend "local" {}
}

provider "azurerm" {
  features {}
}
