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

resource "snowflake_role" "functional_roles" {
  name    = upper(var.name)
  comment = var.comment

  provider = snowflake.securityadmin
}

module "table_grants" {
  source = "./grants/table"

  role_name = var.name
  tables    = var.tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.useradmin     = snowflake.useradmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

output "debug" {
  value = module.table_grants.debug
}