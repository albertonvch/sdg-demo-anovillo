variable "project" {
  type    = string
  default = "sdg"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tags" {
  type = map(string)
}

variable "address_space_vnet1" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "prefix" {
  type = string
}
variable "private_dns_zones" {
  type = map(string)
}
variable "region_code" {
  type    = string
  default = "sc1"
}
