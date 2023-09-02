variable "users" {
  default     = {}
  type = map(object({
    email = optional(string)

    comment    = optional(string)
    first_name = optional(string)
    last_name  = optional(string)

    default_namespace = optional(string)
    default_role      = optional(string)
    default_warehouse = optional(string)

    member_of = optional(list(string))

    rsa_public_key   = optional(string)
    rsa_public_key_2 = optional(string)

    can_login = optional(bool)
    })
  )
}
