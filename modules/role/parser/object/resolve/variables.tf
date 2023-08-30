variable "payload" {
  type = map(object({
    database = string
    schema   = string
    name     = string

    grants            = list(string)
    with_grant_option = optional(bool)
  }))
}

variable "candidates" {
  type = list(object({
    database = string
    schema   = string
    name     = string
    comment  = optional(string)
  }))

  default = []
}
