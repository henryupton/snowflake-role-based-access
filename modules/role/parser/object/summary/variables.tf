variable "payload" {
  type = map(object({
    database = string
    schema   = string
    name     = string

#    grants            = list(string)
#    with_grant_option = optional(bool)
  }))
}
