variable "azure_region" {
  type    = string
  default = "westeurope"
}

#  Resource Group Name
variable "resource_group" {
  type    = string
  default = "Appservice-RG"
}

variable "appservice_name" {
  type = string
  default = "appservicetf"
}