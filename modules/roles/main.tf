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

  external_tables      = lookup(coalesce(each.value.privileges, {}), "external_tables", {})
  file_formats         = lookup(coalesce(each.value.privileges, {}), "file_formats", {})
  functions            = lookup(coalesce(each.value.privileges, {}), "functions", {})
  masking_policies     = lookup(coalesce(each.value.privileges, {}), "masking_policies", {})
  materialized_views   = lookup(coalesce(each.value.privileges, {}), "materialized_views", {})
  pipes                = lookup(coalesce(each.value.privileges, {}), "pipes", {})
  procedures           = lookup(coalesce(each.value.privileges, {}), "procedures", {})
  sequences            = lookup(coalesce(each.value.privileges, {}), "sequences", {})
  stages               = lookup(coalesce(each.value.privileges, {}), "stages", {})
  storage_integrations = lookup(coalesce(each.value.privileges, {}), "storage_integrations", {})
  streams              = lookup(coalesce(each.value.privileges, {}), "streams", {})
  tables               = lookup(coalesce(each.value.privileges, {}), "tables", {})
  tasks                = lookup(coalesce(each.value.privileges, {}), "tasks", {})
  views                = lookup(coalesce(each.value.privileges, {}), "views", {})
  warehouses           = lookup(coalesce(each.value.privileges, {}), "warehouses", {})

  providers            = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "member_of" {
  for_each = var.roles

  source = "../role/member_of"

  role_name = each.key

  include    = lookup(coalesce(each.value.member_of, {}), "include", [])
  exclude    = lookup(coalesce(each.value.member_of, {}), "exclude", [])
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
