variable "role_name" {
  type = string
}

variable "include" {
  type    = set(string)
  default = []
}

variable "exclude" {
  type    = set(string)
  default = []
}