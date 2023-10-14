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

  payload = var.password_policies

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

data "snowflake_password_policies" "password_policies" {
  for_each = module.parse_input.return

  database = upper(each.value.database)
  schema   = upper(each.value.schema)
}

module "resolve_wildcards" {
  for_each = module.parse_input.return

  source = "../../../parser/object/resolve"

  payload    = module.parse_input.return
  candidates = data.snowflake_password_policies.password_policies[each.key].password_policies
}

module "parse_output" {
  source = "../../../parser/object/output"

  payload = module.resolve_wildcards
}

resource "snowflake_grant_privileges_to_role" "grant" {
  for_each = module.parse_output.return

  role_name = upper(var.role_name)

  privileges = each.value.grants

  on_schema_object {
    object_type = upper("password policy")
    object_name = "${each.value.database}.${each.value.schema}.${each.value.name}"
  }

  with_grant_option = each.value.with_grant_option
}

resource "snowflake_grant_privileges_to_role" "future" {
  for_each = module.parse_futures.return

  role_name = var.role_name

  privileges = each.value.grants

  on_schema_object {
    future {
      object_type_plural = upper("password policies")
      in_schema          = "${each.value.database}.${each.value.schema}"
    }
  }

  with_grant_option = each.value.with_grant_option
}

module "summary" {
  source = "../../../parser/object/summary"

  payload = module.parse_output.return
}

output "return" {
  value = module.summary.return
}