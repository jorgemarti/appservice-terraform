resource "azurerm_resource_group" "appservice_rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "random_id" "appservice_name_suffix" {
    byte_length = 8
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "${var.appservice_name}-${random_id.appservice_name_suffix.dec}"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
  # source_control {
  #   repo_url = "https://github.com/azureappserviceoss/ASPNETEmptySite"
  #   branch = "master"
  # }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  # connection_string {
  #   name  = "Database"
  #   type  = "SQLServer"
  #   value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  # }
}