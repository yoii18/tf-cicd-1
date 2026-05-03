resource "azurerm_data_factory_pipeline" "copy_pipeline" {
  name            = "copy_pipeline1"
  data_factory_id = var.adf_id
  activities_json = jsonencode([
    {
      name           = "Copy Data"
      type           = "Copy"
      dependsOn      = []
      userProperties = []
      typeProperties = {
        source = {
          type               = "RestSource"
          httpRequestTimeout = "00:05:00"
          requestMethod      = "GET"
        }
        sink = {
          type = "AzureBlobFSSink"
          storeSettings = {
            type = "AzureBlobFSWriteSettings"
          }
          formatSettings = {
            type = "JsonWriteSettings"
          }
        }
        enableStaging = false
      }
      inputs = [{
        referenceName = var.rest_api_ds_name
        type          = "DatasetReference"
      }]
      outputs = [{
        referenceName = var.adls_ds_name
        type          = "DatasetReference"
      }]
    }
  ])

}
