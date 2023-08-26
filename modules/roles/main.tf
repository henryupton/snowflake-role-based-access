terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.66.1"
      configuration_aliases = [
        snowflake,
        snowflake.securityadmin,
        snowflake.useradmin,
        snowflake.accountadmin,
      ]
    }
  }
}

module "roles" {
  for_each = var.roles

  source = "../role"

  name = each.key

  comment = each.value.comment

  tables               = each.value.tables
  pipes                = each.value.pipes
  views                = each.value.views
  stages               = each.value.stages
  tasks                = each.value.tasks
  streams              = each.value.streams
  external_tables      = each.value.external_tables
  warehouses           = each.value.warehouses
  storage_integrations = each.value.storage_integrations

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.useradmin     = snowflake.useradmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

output "debug" {
  value = module.roles
}
