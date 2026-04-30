resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "storage" {
  source               = "./modules/storage-account"
  location             = azurerm_resource_group.rg.location
  rg_name              = azurerm_resource_group.rg.name
  storage_account_name = var.storage_account_name
}
