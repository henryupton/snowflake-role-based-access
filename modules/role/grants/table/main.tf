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

locals {
  input = {
    for k, v in var.tables : lower(k) => {
      database = split(".", k)[0]
      schema   = split(".", k)[1]
      name     = split(".", k)[2]

      grants            = v.grants
      with_grant_option = coalesce(v.with_grant_option, false)
    }
  }

  # Only grant futures on entire schemas.
  futures = {
    for k, v in local.input : "${v.database}.${v.schema}" => {
      database = upper(v.database)
      schema   = upper(v.schema)

      grants            = v.grants
      with_grant_option = v.with_grant_option
    } if v.name == "*"
  }
}

# Retrieve all tables in each of the provided schemas.
data "snowflake_tables" "table_wildcard" {
  for_each = local.input

  database = upper(each.value.database)
  schema   = upper(each.value.schema)
}

locals {
  resolved_wildcards = flatten([
    for k, v in local.input : [
      for t in coalesce(data.snowflake_tables.table_wildcard[k].tables, []) : {
        database = upper(t.database)
        schema   = upper(t.schema)
        name     = upper(t.name)

        fqn = upper("${t.database}.${t.schema}.${t.name}")

        pattern_matched = k

        grants            = v.grants
        with_grant_option = v.with_grant_option
      }
      if startswith(
        lower(t.name),
        lower(split("*", v.name)[0])  # Match tables which share the prefix before the wildcard.
      )
    ]
  ])

  tables = {
    for i in local.resolved_wildcards : lower("${i.database}.${i.schema}.${i.name}")=> i
  }
}

resource "snowflake_table_grant" "grant" {
  for_each = local.tables

  database_name = each.value.database
  schema_name   = each.value.schema
  table_name    = each.value.name

  privilege = each.value.grants[0]
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true
}

resource "snowflake_table_grant" "futures" {
  for_each = local.futures

  database_name = each.value.database
  schema_name   = each.value.schema

  privilege = each.value.grants[0]
  roles     = [upper(var.role_name)]

  on_future              = true
  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true
}

output "debug" {
  value = {
    "00_input"              = local.input
    "05_resolved_wildcards" = local.resolved_wildcards
  }
}