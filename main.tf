# Run this section, only after creating the required resources below.  Your storage account name must be unique.
terraform {
  backend "azurerm" {
    storage_account_name  = "wildwesttechadmin"
    container_name        = "terraform-statefiles"
    key                   = "azure-initial-setup/terraform.state"
    resource_group_name   = "admin"
  }
}


# Create these items first, then go back and run the terraform block above, to move the statefile to the container
provider "azurerm" {
  features {}
}

# Resource Group For State File and other Central Administrative Resources
resource "azurerm_resource_group" "admin" {
  name     = "admin"
  location = "eastus"
}

# Resource Group For Dev Environment
resource "azurerm_resource_group" "dev" {
  name     = "dev"
  location = "eastus"
}

# Resource Group for Prod Environment
resource "azurerm_resource_group" "prod" {
  name     = "prod"
  location = "eastus"
}

# Create a Storage Account for Administrative Tasks
resource "azurerm_storage_account" "admin" {
  name                     = "wildwesttechadmin"
  resource_group_name      = azurerm_resource_group.admin.name
  location                 = azurerm_resource_group.admin.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create an Administrative Container.  We will store our first state files here.
resource "azurerm_storage_container" "terraform-statefiles" {
  name                  = "terraform-statefiles"
  storage_account_name  = azurerm_storage_account.admin.name
  container_access_type = "private"
}