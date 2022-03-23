terraform {
  backend "local" {
    path = "/Users/jameswilson/terraform_shared_state/alpha-artefacts/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }

  required_version = ">=0.14.9"
}

provider "azurerm" {
  features {}
  # skip_provider_registration = true
  tenant_id = "04007419-cfff-4787-8ed9-a03e0887d337"
}

provider "azuread" {
  tenant_id = "04007419-cfff-4787-8ed9-a03e0887d337"
}