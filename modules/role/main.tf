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

resource "snowflake_role" "roles" {
  name    = upper(var.name)
  comment = var.comment

  provider = snowflake.securityadmin
}

module "parse_schema_wildcards_for_tables" {
  source = "./parser/schema/resolve"

  payload = var.tables

  providers = {
    snowflake = snowflake
  }
}

module "tables" {
  source = "./grants/table"

  role_name = snowflake_role.roles.name
  tables    = module.parse_schema_wildcards_for_tables.return

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

output "debug" {
  value = {
    "01_schema_output" = module.parse_schema_wildcards_for_tables.return

    "04_table_input" = module.tables.debug.input
    "04_table_input_output" = module.tables.debug.input_output

    "05_temp" = module.tables.debug.objects

#    "08_future_grants" = module.tables.debug.futures_by_grant
#    "09_table_grants"  = module.tables.debug.tables_by_grant
  }
}
