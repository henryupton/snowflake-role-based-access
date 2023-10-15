terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.71.0"
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
  payload   = merge(
    var.tables,
    var.stages,
  )

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "alerts" {
  source = "./privileges/object/alert"

  role_name = snowflake_role.roles.name
  alerts    = var.alerts

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "databases" {
  source = "./privileges/account/database"

  role_name = snowflake_role.roles.name
  databases = var.databases

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "dynamic_tables" {
  source = "./privileges/object/dynamic_table"

  role_name      = snowflake_role.roles.name
  dynamic_tables = var.dynamic_tables

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "event_tables" {
  source = "./privileges/object/event_table"

  role_name    = snowflake_role.roles.name
  event_tables = var.event_tables

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

module "failover_groups" {
  source = "./privileges/account/failover_group"

  role_name       = snowflake_role.roles.name
  failover_groups = var.failover_groups

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

module "password_policies" {
  source = "./privileges/object/password_policy"

  role_name         = snowflake_role.roles.name
  password_policies = var.password_policies

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

module "replication_groups" {
  source = "./privileges/account/replication_group"

  role_name          = snowflake_role.roles.name
  replication_groups = var.replication_groups

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "resource_monitors" {
  source = "./privileges/account/resource_monitor"

  role_name         = snowflake_role.roles.name
  resource_monitors = var.resource_monitors

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "row_access_policies" {
  source = "./privileges/object/row_access_policy"

  role_name           = snowflake_role.roles.name
  row_access_policies = var.row_access_policies

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "secrets" {
  source = "./privileges/object/secret"

  role_name = snowflake_role.roles.name
  secrets   = var.secrets

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

module "session_policies" {
  source = "./privileges/object/session_policy"

  role_name        = snowflake_role.roles.name
  session_policies = var.session_policies

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
  source = "./privileges/account/storage_integration"

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

module "tags" {
  source = "./privileges/object/tag"

  role_name = snowflake_role.roles.name
  tags      = var.tags

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

module "users" {
  source = "./privileges/account/user"

  role_name = snowflake_role.roles.name
  users     = var.users

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
  source = "./privileges/account/warehouse"

  role_name  = snowflake_role.roles.name
  warehouses = var.warehouses

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

output "privileges" {
  value = {
    alerts               = module.alerts.return
    databases            = module.databases.return
    dynamic_tables       = module.dynamic_tables.return
    event_tables         = module.event_tables.return
    external_tables      = module.external_tables.return
    failover_groups      = module.failover_groups.return
    file_formats         = module.file_formats.return
    functions            = module.functions.return
    masking_policies     = module.masking_policies.return
    materialized_views   = module.materialized_views.return
    password_policies    = module.password_policies.return
    pipes                = module.pipes.return
    procedures           = module.procedures.return
    replication_groups   = module.replication_groups.return
    resource_monitors    = module.resource_monitors.return
    row_access_policies  = module.row_access_policies.return
    secrets              = module.secrets.return
    sequences            = module.sequences.return
    session_policies     = module.session_policies.return
    stages               = module.stages.return
    storage_integrations = module.storage_integrations.return
    streams              = module.streams.return
    tables               = module.tables.return
    tags                 = module.tags.return
    tasks                = module.tasks.return
    users                = module.users.return
    views                = module.views.return
    warehouses           = module.warehouses.return
  }
}
