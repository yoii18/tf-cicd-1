output "adf_id" {
  value = azurerm_data_factory.adf.id
}

output "adls_ds_name" {
  value = azurerm_data_factory_custom_dataset.adls_ds.name
}

output "rest_api_ds_name" {
  value = azurerm_data_factory_custom_dataset.rest_api_ds.name
}
