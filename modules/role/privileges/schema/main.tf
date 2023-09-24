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
}

resource "snowflake_schema_grant" "usage" {
  for_each = local.schemas

  database_name = upper(split(".", each.value)[0])
  schema_name   = upper(split(".", each.value)[1])

  privilege = "USAGE"
  roles     = [var.role_name]

  with_grant_option = false
}