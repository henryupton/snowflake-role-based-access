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

module "tables" {
  source = "./grants/table"

  role_name = snowflake_role.roles.name
  tables    = var.tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "stages" {
  source = "./grants/stage"

  role_name = snowflake_role.roles.name
  stages    = var.stages

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

output "debug" {
  value = {
    table_input  = module.tables.debug.input
    table_output = module.tables.debug.output

    stage_input  = module.stages.debug.input
    stage_output = module.stages.debug.output
  }
}
