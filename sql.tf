resource "azurerm_sql_server" "example" {
  name                         = "sqlserver-${random_id.appservice_name_suffix.dec}"
  resource_group_name          = azurerm_resource_group.appservice_rg.name
  location                     = azurerm_resource_group.appservice_rg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "example" {
  name                = "sqldatabase"
  resource_group_name          = azurerm_resource_group.appservice_rg.name
  location                     = azurerm_resource_group.appservice_rg.location
  server_name         = azurerm_sql_server.example.name

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.appservice_rg.name
  server_name         = azurerm_sql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}