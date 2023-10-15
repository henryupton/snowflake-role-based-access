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
  _objects_by_grant = [
    for k, v in coalesce(var.replication_groups, {}) : {
        name = k

        grants             = v.grants
        with_grant_option = v.with_grant_option
      }
  ]

  objects_by_grant = merge(
    {
      for i in local._objects_by_grant : lower(i.name) => i
    }
  )
}

resource "snowflake_grant_privileges_to_role" "grant" {
  for_each = local.objects_by_grant

  privileges = each.value.grants
  role_name  = var.role_name

  on_account_object {
    object_type = upper("replication group")
    object_name = upper(each.value.name)
  }

  with_grant_option = each.value.with_grant_option

  provider = snowflake.securityadmin
}

output "return" {
  value = [ for k, v in coalesce(var.replication_groups, {}) : k ]
}