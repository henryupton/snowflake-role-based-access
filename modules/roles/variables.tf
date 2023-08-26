variable "roles" {
  type = map(object({
    comment = optional(string)
    tables = optional(map(object({
      grants            = list(string)
      with_grant_option = optional(bool)
    })))
    stages = optional(map(object({
      grants            = list(string)
      with_grant_option = optional(bool)
    })))
    pipes = optional(map(object({
      grants            = list(string)
      with_grant_option = optional(bool)
    })))
    views = optional(map(object({
      grants            = list(string)
      with_grant_option = optional(bool)
    })))
  }))
}