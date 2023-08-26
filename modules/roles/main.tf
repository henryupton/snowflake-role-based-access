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

  tables = each.value.tables
  pipes  = each.value.pipes
  views  = each.value.views
  stages = each.value.stages

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
