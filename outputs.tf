locals {
  scm_username = azurerm_app_service.example.site_credential.0.username
  scm_password = azurerm_app_service.example.site_credential.0.password
  repo_uri     = "${replace(azurerm_app_service.example.source_control.0.repo_url, "https://", "")}"
}
output "credentials" {
  value = azurerm_app_service.example.site_credential
}

output "repository_url" {
  value = "https://${local.scm_username}:${local.scm_password}@${local.repo_uri}/${azurerm_app_service.example.name}.git"
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.example.default_site_hostname}"
}