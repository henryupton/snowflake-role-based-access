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

module "parse_schema_wildcards" {
  source = "../../parser/schema/resolve"

  payload = var.payload

  providers = {
    snowflake = snowflake
  }
}

locals {
  databases = toset([for k, v in module.parse_schema_wildcards.return : split(".", k)[0] ])
  schemas   = toset([for k, v in module.parse_schema_wildcards.return : "${split(".", k)[0]}.${split(".", k)[1]}"])
}

resource "snowflake_database_grant" "usage" {
  for_each      = local.databases
  database_name = upper(each.value)

  privilege = "USAGE"
  roles     = [var.role_name]

  with_grant_option = false

  provider = snowflake.securityadmin
}

resource "snowflake_grant_privileges_to_role" "usage" {
  for_each = local.schemas

  privileges = ["USAGE"]
  role_name  = var.role_name

  on_schema {
    schema_name = upper("${split(".", each.value)[0]}.${split(".", each.value)[1]}")
  }

  with_grant_option = false

  provider = snowflake.securityadmin
}
