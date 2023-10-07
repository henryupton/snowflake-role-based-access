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

module "parse_schema_wildcards" {
  source = "../../../parser/schema/resolve"

  payload = var.sequences

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

data "snowflake_sequences" "sequences" {
  for_each = module.parse_input.return

  database = upper(each.value.database)
  schema   = upper(each.value.schema)
}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_sequences.sequences[each.key].sequences
}

module "parse_output" {
  source = "../../../parser/object/output"

  payload = module.resolve_wildcards
}

resource "snowflake_sequence_grant" "grant" {
  for_each = module.parse_output.return

  database_name = each.value.database
  schema_name   = each.value.schema
  sequence_name    = each.value.name

  privilege = upper(each.value.grant)
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

resource "snowflake_sequence_grant" "futures" {
  for_each = module.parse_futures.return

  database_name = each.value.database
  schema_name   = each.value.schema

  privilege = upper(each.value.grant)
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