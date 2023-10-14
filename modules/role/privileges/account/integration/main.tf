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
    for k, v in coalesce(var.integrations, {}) : [
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

resource "snowflake_grant_privileges_to_role" "grant" {
  for_each = local.objects_by_grant

  privileges = each.value.grants
  role_name  = var.role_name

  on_account_object {
    object_type = upper("integration")
    object_name = upper(each.value.name)
  }

  with_grant_option = each.value.with_grant_option

  provider = snowflake.securityadmin
}

output "return" {
  value = [ for k, v in coalesce(var.integrations, {}) : k ]
}