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
