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

variable "pipes" {
  type = map(object({
    grants = list(string)
  }))
  default = {}
}
