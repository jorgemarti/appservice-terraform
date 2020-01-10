terraform {
  backend "azurerm" {
    key                  = "appservice.terraform.tfstate"
  }
}