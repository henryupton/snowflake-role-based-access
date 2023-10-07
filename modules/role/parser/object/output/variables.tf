variable "payload" {
  type = map(object({
    return = map(object({
      database = string
      schema   = string
      name     = string

      fqn             = string
      pattern_matched = string

      grants            = list(string)
      with_grant_option = optional(bool)
    }))
  }))
}