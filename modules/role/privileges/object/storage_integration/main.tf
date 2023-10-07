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

module "parse_input" {
  source = "../../../parser/object/input"

  payload = var.storage_integrations
}

data "snowflake_storage_integrations" "storage_integrations" {}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_storage_integrations.storage_integrations.storage_integrations
}

module "parse_output" {
  source = "../../../parser/object/output"

  payload = module.resolve_wildcards
}

resource "snowflake_integration_grant" "grant" {
  for_each = module.parse_output.return

  integration_name    = each.value.name

  privilege = upper(each.value.grant)
  roles     = [upper(var.role_name)]

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