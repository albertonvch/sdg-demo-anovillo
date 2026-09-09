variable "project" {
  type    = string
  default = "sdg"
}

variable "location" {
  type    = string
  default = "swedencentral"
}


variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type = string
}

variable "private_dns_zones" {
  type = map(string)
}
