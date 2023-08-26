variable "name" {
  type = string
}

variable "comment" {
  type    = string
  default = null
}

variable "tables" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "pipes" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "stages" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "views" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "tasks" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "streams" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "external_tables" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "warehouses" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}

variable "storage_integrations" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}
