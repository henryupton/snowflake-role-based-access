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

module "parse_input" {
  source = "../../parser/object/input"

  payload = var.tables

  providers = {
    snowflake = snowflake
  }
}

module "parse_futures" {
  source = "../../parser/object/futures"

  payload = module.parse_input.return

  providers = {
    snowflake = snowflake
  }
}

# Retrieve all tables in each of the provided schemas.
data "snowflake_tables" "tables" {
  for_each = module.parse_input.return

  database = upper(each.value.database)
  schema   = upper(each.value.schema)
}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_tables.tables[each.key].tables

  providers = {
    snowflake = snowflake
  }
}

# Flatten the output of the resolution process.
# BOILERPLATE BEGINS!
locals {
  objects_in_pattern = {
    for object_pattern, object_map in module.resolve_wildcards : object_pattern => object_map.return
    if length(object_map.return) > 0
  }

  flat_objects = toset(  # This is important as it allows overlap between the wildcards resulting in an OR like behavior.
    flatten(
      [
        for object_pattern, object_map in local.objects_in_pattern : [
        for k, v in object_map : {
          key      = k
          database = v.database
          schema   = v.schema
          name     = v.name

          grant             = v.grant
          with_grant_option = v.with_grant_option
        }
      ]
      ]
    )
  )

  flat_object_map = {
    for obj in local.flat_objects : obj.key => {
      database = obj.database
      schema   = obj.schema
      name     = obj.name

      grant             = obj.grant
      with_grant_option = obj.with_grant_option
    }
  }
}
# BOILERPLATE ENDS!

resource "snowflake_table_grant" "grant" {
  for_each = local.flat_object_map

  database_name = each.value.database
  schema_name   = each.value.schema
  table_name    = each.value.name

  privilege = each.value.grant
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

resource "snowflake_table_grant" "futures" {
  for_each = module.parse_futures.return

  database_name = each.value.database
  schema_name   = each.value.schema

  privilege = each.value.grant
  roles     = [upper(var.role_name)]

  on_future              = true
  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

output "debug" {
  value = {
    input        = var.tables
    input_output = module.parse_input.return
    objects      = local.flat_object_map# module.flatten.return
    #    futures_by_grant = module.parse_futures.return
    #    tables_by_grant = module.resolve_wildcards.return
  }
}