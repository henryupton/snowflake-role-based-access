terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.80.0"
      configuration_aliases = [
        snowflake,
        snowflake.securityadmin,
        snowflake.accountadmin,
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
  payload   = merge(
    var.tables,
    var.stages,
  )

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "alerts" {
  source = "./privileges/object/alert"

  role_name = snowflake_role.roles.name
  alerts    = var.alerts

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "databases" {
  source = "./privileges/account/database"

  role_name = snowflake_role.roles.name
  databases = var.databases

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "external_tables" {
  source = "./privileges/object/external_table"

  role_name       = snowflake_role.roles.name
  external_tables = var.external_tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "failover_groups" {
  source = "./privileges/account/failover_group"

  role_name       = snowflake_role.roles.name
  failover_groups = var.failover_groups

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "file_formats" {
  source = "./privileges/object/file_format"

  role_name    = snowflake_role.roles.name
  file_formats = var.file_formats

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "functions" {
  source = "./privileges/object/function"

  role_name = snowflake_role.roles.name
  functions = var.functions

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "masking_policies" {
  source = "./privileges/object/masking_policy"

  role_name        = snowflake_role.roles.name
  masking_policies = var.masking_policies

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "materialized_views" {
  source = "./privileges/object/materialized_view"

  role_name          = snowflake_role.roles.name
  materialized_views = var.materialized_views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "pipes" {
  source = "./privileges/object/pipe"

  role_name = snowflake_role.roles.name
  pipes     = var.pipes

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "procedures" {
  source = "./privileges/object/procedure"

  role_name  = snowflake_role.roles.name
  procedures = var.procedures

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "replication_groups" {
  source = "./privileges/account/replication_group"

  role_name          = snowflake_role.roles.name
  replication_groups = var.replication_groups

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "resource_monitors" {
  source = "./privileges/account/resource_monitor"

  role_name         = snowflake_role.roles.name
  resource_monitors = var.resource_monitors

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "row_access_policies" {
  source = "./privileges/object/row_access_policy"

  role_name           = snowflake_role.roles.name
  row_access_policies = var.row_access_policies

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "sequences" {
  source = "./privileges/object/sequence"

  role_name = snowflake_role.roles.name
  sequences = var.sequences

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "stages" {
  source = "./privileges/object/stage"

  role_name = snowflake_role.roles.name
  stages    = var.stages

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "storage_integrations" {
  source = "./privileges/account/storage_integration"

  role_name            = snowflake_role.roles.name
  storage_integrations = var.storage_integrations

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "streams" {
  source = "./privileges/object/stream"

  role_name = snowflake_role.roles.name
  streams   = var.streams

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "tables" {
  source = "./privileges/object/table"

  role_name = snowflake_role.roles.name
  tables    = var.tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "tasks" {
  source = "./privileges/object/task"

  role_name = snowflake_role.roles.name
  tasks     = var.tasks

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "users" {
  source = "./privileges/account/user"

  role_name = snowflake_role.roles.name
  users     = var.users

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "views" {
  source = "./privileges/object/view"

  role_name = snowflake_role.roles.name
  views     = var.views

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "warehouses" {
  source = "./privileges/account/warehouse"

  role_name  = snowflake_role.roles.name
  warehouses = var.warehouses

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

output "input" {
  value = merge(var.warehouses, var.tables)
}

output "privileges" {
  value = {
    alerts               = module.alerts.return
    databases            = module.databases.return
    external_tables      = module.external_tables.return
    failover_groups      = module.failover_groups.return
    file_formats         = module.file_formats.return
    functions            = module.functions.return
    masking_policies     = module.masking_policies.return
    materialized_views   = module.materialized_views.return
    pipes                = module.pipes.return
    procedures           = module.procedures.return
    replication_groups   = module.replication_groups.return
    resource_monitors    = module.resource_monitors.return
    row_access_policies  = module.row_access_policies.return
    sequences            = module.sequences.return
    stages               = module.stages.return
    storage_integrations = module.storage_integrations.return
    streams              = module.streams.return
    tables               = module.tables.return
    tasks                = module.tasks.return
    users                = module.users.return
    views                = module.views.return
    warehouses           = module.warehouses.return
  }
}
