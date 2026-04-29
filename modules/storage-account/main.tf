resource "azurerm_storage_account" "strgacct" {
  location                 = var.location
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  access_tier              = "Cool"
  min_tls_version          = "TLS1_2"
}
