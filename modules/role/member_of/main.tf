terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.66.1"
      configuration_aliases = [
        snowflake,
        snowflake.securityadmin,
      ]
    }
  }
}

locals {
  include = {
    for role_pattern in coalesce(var.include, []) : upper(replace(role_pattern, "*", "%")) => null
  }
  exclude = {
    for role_pattern in coalesce(var.exclude, []) : upper(replace(role_pattern, "*", "%")) => null
  }
}

data "snowflake_roles" "include" {
  for_each = local.include

  pattern = each.key
}

data "snowflake_roles" "exclude" {
  for_each = local.exclude

  pattern = each.key
}

locals {
  include_flattened = toset([
    for response in data.snowflake_roles.include : [
      for role in response.roles : role.name
    ]
  ])
  exclude_flattened = toset([
    for response in data.snowflake_roles.exclude : [
      for role in response.roles : role.name
    ]
  ])

  roles = {
    for role in setsubtract(local.include_flattened, local.exclude_flattened) : role => null
  }
}

#resource "snowflake_role_grants" "grants" {
#  for_each = local.roles
#
#  role_name = each.key
#
#  roles = [var.role_name]
#
#  provider = snowflake.securityadmin
#}

output "roles" {
  value = [for role in local.roles : lower(role)]
}
