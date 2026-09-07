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
