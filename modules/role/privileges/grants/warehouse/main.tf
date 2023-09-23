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
  source = "../../../parser/object/input"

  payload = var.warehouses
}

data "snowflake_warehouses" "warehouses" {}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_warehouses.warehouses.warehouses
}

module "parse_output" {
  source = "../../../parser/object/output"

  payload = module.resolve_wildcards
}

resource "snowflake_warehouse_grant" "grant" {
  for_each = module.parse_output.return

  warehouse_name    = each.value.name

  privilege = upper(each.value.grant)
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

module "summary" {
  source = "../../../parser/object/summary"

  payload = module.parse_input.return
}

output "return" {
  value = module.summary.return
}