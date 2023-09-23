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

module "external_tables" {
  source = "./privileges/grants/external_table"

  role_name       = snowflake_role.roles.name
  external_tables = var.external_tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "file_formats" {
  source = "./privileges/grants/file_format"

  role_name    = snowflake_role.roles.name
  file_formats = var.file_formats

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "functions" {
  source = "./privileges/grants/function"

  role_name = snowflake_role.roles.name
  functions = var.functions

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "masking_policies" {
  source = "./privileges/grants/masking_policy"

  role_name        = snowflake_role.roles.name
  masking_policies = var.masking_policies

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "materialized_views" {
  source = "./privileges/grants/materialized_view"

  role_name          = snowflake_role.roles.name
  materialized_views = var.materialized_views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "pipes" {
  source = "./privileges/grants/pipe"

  role_name = snowflake_role.roles.name
  pipes     = var.pipes

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "procedures" {
  source = "./privileges/grants/procedure"

  role_name  = snowflake_role.roles.name
  procedures = var.procedures

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "sequences" {
  source = "./privileges/grants/sequence"

  role_name = snowflake_role.roles.name
  sequences = var.sequences

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "stages" {
  source = "./privileges/grants/stage"

  role_name = snowflake_role.roles.name
  stages    = var.stages

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "storage_integrations" {
  source = "./privileges/grants/storage_integration"

  role_name            = snowflake_role.roles.name
  storage_integrations = var.storage_integrations

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "streams" {
  source = "./privileges/grants/stream"

  role_name = snowflake_role.roles.name
  streams   = var.streams

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "tables" {
  source = "./privileges/grants/table"

  role_name = snowflake_role.roles.name
  tables    = var.tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "tasks" {
  source = "./privileges/grants/task"

  role_name = snowflake_role.roles.name
  tasks     = var.tasks

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "views" {
  source = "./privileges/grants/view"

  role_name = snowflake_role.roles.name
  views     = var.views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "warehouses" {
  source = "./privileges/grants/warehouse"

  role_name  = snowflake_role.roles.name
  warehouses = var.warehouses

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

output "privileges" {
  value = {
    external_tables      = module.external_tables.return
    file_formats         = module.file_formats.return
    functions            = module.functions.return
    masking_policies     = module.masking_policies.return
    materialized_views   = module.materialized_views.return
    pipes                = module.pipes.return
    procedures           = module.procedures.return
    sequences            = module.sequences.return
    stages               = module.stages.return
    storage_integrations = module.storage_integrations.return
    streams              = module.streams.return
    tables               = module.tables.return
    tasks                = module.tasks.return
    views                = module.views.return
    warehouses           = module.warehouses.return
  }
}
