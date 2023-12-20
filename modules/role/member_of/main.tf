terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.80.0"
      configuration_aliases = [
        snowflake,
        snowflake.securityadmin,
        snowflake.accountadmin,
    ]
    }
  }
}

locals {
  system_roles = toset([
    "accountadmin",
    "orgadmin",
    "securityadmin",
    "sysadmin",
    "useradmin",
  ])

  candidates = setunion(local.system_roles, var.candidates)
}

locals {
  include = [
    for role_pattern in coalesce(var.include, []) : lower(role_pattern)
  ]
  # Always exclude this role itself.
  exclude = [
    for role_pattern in setunion(coalesce(var.exclude, []), toset([lower(var.role_name)])) : lower(role_pattern)
  ]
}

locals {
  include_flattened = toset(flatten([
    for include in local.include : [
      for role in local.candidates : role
      if startswith(
        lower(role),
        lower(split("*", include)[0])  # Match roles which share the prefix before the wildcard.
      )
    ]
  ]))
  exclude_flattened = toset(flatten([
    for exclude in local.exclude : [
      for role in local.candidates : role
      if startswith(
        lower(role),
        lower(split("*", exclude)[0])
      )
    ]
  ]))

  roles = setsubtract(local.include_flattened, local.exclude_flattened)
}

resource "snowflake_role_grants" "grants" {
  for_each = local.roles

  role_name = upper(each.key)

  roles = [upper(var.role_name)]

  provider = snowflake.securityadmin
}

output "member_of" {
  value = [for role in local.roles : lower(role)]
}
