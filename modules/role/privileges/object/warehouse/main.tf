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

locals {
  _objects_by_grant = flatten([
    for k, v in var.warehouses : [
      for g in v.grants : {
        name = k

        grant             = g
        with_grant_option = v.with_grant_option
      }
    ]
  ])

  objects_by_grant = merge(
    {
      for i in local._objects_by_grant : lower("${i.name}|${i.grant}") => i
    }
  )
}

resource "snowflake_warehouse_grant" "grant" {
  for_each = local.objects_by_grant

  warehouse_name = upper(each.value.name)

  privilege = upper(each.value.grant)
  roles     = [upper(var.role_name)]

  with_grant_option      = each.value.with_grant_option
  enable_multiple_grants = true

  provider = snowflake.securityadmin
}

output "return" {
  value = [ for k, v in var.warehouses : k ]
}