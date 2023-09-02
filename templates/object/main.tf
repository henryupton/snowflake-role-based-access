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

module "parse_schema_wildcards" {
  source = "../../../parser/schema/resolve"

  payload = var.{{ object }}s

  providers = {
    snowflake = snowflake
  }
}


module "parse_input" {
  source = "../../../parser/object/input"

  payload = module.parse_schema_wildcards.return
}

module "parse_futures" {
  source = "../../../parser/object/futures"

  payload = module.parse_input.return
}

data "snowflake_{{ object }}s" "{{ object }}s" {
  for_each = module.parse_input.return

  database = upper(each.value.database)
  schema   = upper(each.value.schema)
}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_{{ object }}s.{{ object }}s[each.key].{{ object }}s
}

module "parse_output" {
  source = "../../../parser/object/output"

  payload = module.resolve_wildcards
}

resource "snowflake_{{ object }}_grant" "grant" {
  for_each = module.parse_output.return

  database_name = each.value.database
  schema_name   = each.value.schema
  {{ object }}_name    = each.value.name

  privilege = each.value.grant
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

resource "snowflake_{{ object }}_grant" "futures" {
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

module "summary" {
  source = "../../../parser/object/summary"

  payload = module.parse_output.return
}

output "return" {
  value = module.summary.return
}