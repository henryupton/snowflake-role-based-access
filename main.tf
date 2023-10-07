module "roles" {
  source = "./modules/roles"

  # Read all yaml files in this dir.
  roles = merge(
    [
      for f in fileset(path.module, "*.{yml,yaml}") : lookup(
      yamldecode(
        file(f)
      ),
      "roles",
      {}
    )
    ]...  # Allows us to merge all the maps in our list.
  )

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
  }
}

module "users" {
  source = "./modules/users"

  users = merge(
    [
      for f in fileset(path.module, "*.{yml,yaml}") : lookup(
      yamldecode(
        file(f)
      ),
      "users",
      {}
    )
    ]...
  )

  providers = {
    snowflake               = snowflake
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.useradmin     = snowflake.useradmin
  }
}

data "snowflake_current_account" "this" {}

output "state" {
  value = {
    roles   = module.roles.debug
    users   = module.users.debug
    account = {
      name   = data.snowflake_current_account.this.account
      url    = data.snowflake_current_account.this.url
      region = data.snowflake_current_account.this.region
    }
  }
}