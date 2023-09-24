variable "storage_integrations" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
}

variable "role_name" {
  type = string
}