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

module "parse_schema_wildcards_for_tables" {
  source = "./parser/schema"

  payload = var.tables

  providers = {
    snowflake = snowflake
  }
}

module "tables" {
  source = "./grants/table"

  role_name = snowflake_role.functional_roles.name
  tables    = module.parse_schema_wildcards_for_tables.output

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.useradmin     = snowflake.useradmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

output "debug" {
  value = {
    "00_schema_input"  = module.parse_schema_wildcards_for_tables.input
    "01_schema_output" = module.parse_schema_wildcards_for_tables.output

    "04_table_input" = module.tables.debug.input

    "08_future_grants" = module.tables.debug.futures_by_grant
    "09_table_grants"  = module.tables.debug.tables_by_grant
  }
}
