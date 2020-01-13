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
    "ASPNETCORE_ENVIRONMENT" = "Production"
    "ASPNETCORE_DETAILEDERRORS" = true
  }

 connection_string {
    name  = "MyDatabase"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_sql_server.example.fully_qualified_domain_name},1433;Database=${azurerm_sql_database.example.name};User ID=${azurerm_sql_server.example.administrator_login};Password=${azurerm_sql_server.example.administrator_login_password};Encrypt=true;Connection Timeout=30;"
#See here: https://www.connectionstrings.com/azure-sql-database/
  }
}