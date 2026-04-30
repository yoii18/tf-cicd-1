resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "storage" {
  source               = "./modules/storage-account"
  location             = var.location
  rg_name              = var.rg_name
  storage_account_name = var.storage_account_name
}
