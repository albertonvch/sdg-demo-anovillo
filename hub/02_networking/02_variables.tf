variable "project" {
  type    = string
  default = "sdg"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tags" {
  type = map(string)
}

variable "address_space_vnet1" {
  type = list(string)
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
