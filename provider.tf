terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=2.46.0"
            }
        google = {
            source = "hashicorp/google"
            version = "3.76.0"
            }            
        }
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "grappler92"

        workspaces {
            name = "azure"
        }
    }
}

provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID    
  features {}
}

provider "google" {
    project         = var.ARM_PROJECT
    credentials     = var.GOOGLE_CLOUD_KEYFILE_JSON
}