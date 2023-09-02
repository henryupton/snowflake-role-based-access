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

module "roles" {
  for_each = var.roles

  source = "../role"

  name = each.key

  comment = each.value.comment

  tables               = lookup(coalesce(each.value.privileges, {}), "tables", {})
  pipes                = lookup(coalesce(each.value.privileges, {}), "pipes", {})
  views                = lookup(coalesce(each.value.privileges, {}), "views", {})
  stages               = lookup(coalesce(each.value.privileges, {}), "stages", {})
  tasks                = lookup(coalesce(each.value.privileges, {}), "tasks", {})
  streams              = lookup(coalesce(each.value.privileges, {}), "streams", {})
  external_tables      = lookup(coalesce(each.value.privileges, {}), "external_tables", {})
  warehouses           = lookup(coalesce(each.value.privileges, {}), "warehouses", {})
  storage_integrations = lookup(coalesce(each.value.privileges, {}), "storage_integrations", {})

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "member_of" {
  for_each = var.roles

  source = "../role/member_of"

  role_name = each.key

  include = lookup(coalesce(each.value.member_of, {}), "include", [])
  exclude = lookup(coalesce(each.value.member_of, {}), "exclude", [])
  candidates = toset([for k, v in var.roles : k])

  depends_on = [module.roles]

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

output "debug" {
  value = module.roles
}
