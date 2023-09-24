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

module "schemas" {
  source = "./privileges/schema"

  role_name = snowflake_role.roles.name
  payload = merge(
    var.tables,
    var.stages,
  )

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "external_tables" {
  source = "./privileges/object/external_table"

  role_name       = snowflake_role.roles.name
  external_tables = var.external_tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "file_formats" {
  source = "./privileges/object/file_format"

  role_name    = snowflake_role.roles.name
  file_formats = var.file_formats

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "functions" {
  source = "./privileges/object/function"

  role_name = snowflake_role.roles.name
  functions = var.functions

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "masking_policies" {
  source = "./privileges/object/masking_policy"

  role_name        = snowflake_role.roles.name
  masking_policies = var.masking_policies

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "materialized_views" {
  source = "./privileges/object/materialized_view"

  role_name          = snowflake_role.roles.name
  materialized_views = var.materialized_views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "pipes" {
  source = "./privileges/object/pipe"

  role_name = snowflake_role.roles.name
  pipes     = var.pipes

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "procedures" {
  source = "./privileges/object/procedure"

  role_name  = snowflake_role.roles.name
  procedures = var.procedures

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "sequences" {
  source = "./privileges/object/sequence"

  role_name = snowflake_role.roles.name
  sequences = var.sequences

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "stages" {
  source = "./privileges/object/stage"

  role_name = snowflake_role.roles.name
  stages    = var.stages

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "storage_integrations" {
  source = "./privileges/object/storage_integration"

  role_name            = snowflake_role.roles.name
  storage_integrations = var.storage_integrations

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "streams" {
  source = "./privileges/object/stream"

  role_name = snowflake_role.roles.name
  streams   = var.streams

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "tables" {
  source = "./privileges/object/table"

  role_name = snowflake_role.roles.name
  tables    = var.tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "tasks" {
  source = "./privileges/object/task"

  role_name = snowflake_role.roles.name
  tasks     = var.tasks

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "views" {
  source = "./privileges/object/view"

  role_name = snowflake_role.roles.name
  views     = var.views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "warehouses" {
  source = "./privileges/object/warehouse"

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
