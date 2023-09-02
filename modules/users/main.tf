terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.66.1"
      configuration_aliases = [
        snowflake,
        snowflake.securityadmin,
        snowflake.useradmin,
      ]
    }

  }
}

resource "snowflake_user" "users" {
  for_each = var.users

  name       = upper(each.key)
  login_name = upper(coalesce(each.value.email, each.key))
  email      = try(upper(each.value.email), null)

  comment    = each.value.comment
  first_name = each.value.first_name
  last_name  = each.value.last_name

  default_role      = each.value.default_role
  default_namespace = each.value.default_namespace
  default_warehouse = each.value.default_warehouse

  rsa_public_key   = each.value.rsa_public_key
  rsa_public_key_2 = each.value.rsa_public_key_2

  disabled = !coalesce(each.value.can_login, false)

  provider = snowflake.useradmin

  lifecycle {
    ignore_changes = [
      password,
      must_change_password
    ]
  }
}

# It is nicer to map roles to users rather than users to roles so we flip the script here.
locals {
  users_to_roles = {
    for user, user_data in var.users : upper(user) => user_data.member_of
  }
  roles_to_users = transpose(local.users_to_roles)
}

resource "snowflake_role_grants" "grant_to_roles" {
  enable_multiple_grants = true

  for_each = local.roles_to_users

  role_name = upper(each.key)
  users     = [for user in each.value : upper(user)]

  provider = snowflake.securityadmin

  depends_on = [snowflake_user.users]
}

output debug {
  value = var.users
}
