resource "azurerm_user_assigned_identity" "adf_uai" {
  name                = "uai-${var.adf_name}"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_role_assignment" "adf_adls_access" {
  scope                = var.scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.adf_uai.principal_id
}

resource "azurerm_data_factory" "adf" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = var.adf_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.adf_uai.id]
  }
  depends_on = [azurerm_role_assignment.adf_adls_access]
}

resource "azurerm_data_factory_linked_custom_service" "rest_api_ls" {
  name            = "rest_api_ls"
  type            = "RestService"
  data_factory_id = azurerm_data_factory.adf.id
  type_properties_json = jsonencode({
    authenticationType = "Anonymous"
    url                = "https://codeforces.com/"
  })
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_ls" {
  name                 = "adls_ls"
  data_factory_id      = azurerm_data_factory.adf.id
  use_managed_identity = true
  url                  = "https://${var.storage_account_name}.dfs.core.windows.net"
}

resource "azurerm_data_factory_custom_dataset" "rest_api_ds" {
  name            = "rest_api_ds"
  type            = "RestResource"
  data_factory_id = azurerm_data_factory.adf.id
  linked_service {
    name = azurerm_data_factory_linked_custom_service.rest_api_ls.name
  }
  type_properties_json = jsonencode({
    relativeUrl   = "api/contest.list?gym=true"
    requestMethod = "GET"
    requestBody   = ""
  })
}

resource "azurerm_data_factory_custom_dataset" "adls_ds" {
  name            = "adls_dataset"
  data_factory_id = azurerm_data_factory.adf.id
  type            = "AzureBlobFSFile"
  linked_service {
    name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_ls.name
  }
  type_properties_json = jsonencode({
    location = {
      type       = "AzureBlobFSLocation"
      fileSystem = "staging"
      folderPath = "raw/data"
      fileName   = "data.parquet"
    }
    compression = {
      type = "None"
    }
  })
  schema_json = jsonencode([])
}
