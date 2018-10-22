# Configure the Azure ARM provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "ResourceGrps" {
  name     = "asotelo-terraform-n-tier"
  location = "West US 2"
}
