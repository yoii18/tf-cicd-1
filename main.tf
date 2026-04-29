module "storage" {
  source               = "./modules/storage-account"
  location             = var.location
  rg_name              = var.rg_name
  storage_account_name = var.storage_account_name
}
