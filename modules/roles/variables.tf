variable "roles" {
  type = map(object({
    comment = optional(string)

    member_of = optional(object({
      include = optional(list(string))
      exclude = optional(list(string))
    }))

    privileges = optional(object({
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
      tasks = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      streams = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      external_tables = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      warehouses = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      storage_integrations = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
    }))
  }))
}