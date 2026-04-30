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

module "adf" {
  source               = "./modules/data-factory"
  location             = azurerm_resource_group.rg.location
  rg_name              = azurerm_resource_group.rg.name
  storage_account_name = var.storage_account_name
  adf_name             = var.adf_name
}

module "pipeline" {
  source               = "./modules/pipelines"
  location             = azurerm_resource_group.rg.location
  rg_name              = azurerm_resource_group.rg.name
  adf_name             = var.adf_name
  adf_id               = module.adf.adf_id
  storage_account_name = var.storage_account_name
  adls_ds_name         = module.adf.adls_ds_name
  rest_api_ds_name     = module.adf.rest_api_ds_name
}
