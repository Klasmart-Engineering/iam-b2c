
resource "azurerm_storage_account" "authenication_artefacts" {
  name                     = "authenication_artefacts"
  resource_group_name      = azurerm_resource_group.authenication_group.name
  location                 = azurerm_resource_group.authenication_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "development"
  }
}