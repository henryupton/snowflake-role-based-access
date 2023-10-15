variable "name" {
  type = string
}

variable "comment" {
  type    = string
  default = null
}

variable "alerts" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "databases" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "dynamic_tables" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "event_tables" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "external_tables" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "failover_groups" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "file_formats" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "functions" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "masking_policies" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "materialized_views" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "password_policies" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "pipes" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "procedures" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "replication_groups" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "resource_monitors" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "row_access_policies" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "secrets" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "sequences" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "session_policies" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "stages" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "storage_integrations" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "streams" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "tables" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "tags" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "tasks" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "users" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "views" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}

variable "warehouses" {
  type = map(object({
    grants            = list(string)
    with_grant_option = optional(bool)
  }))
  default = {}
}
