variable "roles" {
  type = map(object({
    comment = optional(string)

    member_of = optional(object({
      include = optional(list(string))
      exclude = optional(list(string))
    }))

    privileges = optional(object({
      external_tables = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      file_formats = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      functions = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      masking_policies = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      materialized_views = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      pipes = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      procedures = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      sequences = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      stages = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      integrations = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      streams = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      tables = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      tasks = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      views = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
      warehouses = optional(map(object({
        grants            = list(string)
        with_grant_option = optional(bool)
      })))
    }))
  }))
}