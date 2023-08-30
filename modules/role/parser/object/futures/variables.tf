variable "payload" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
}