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
      for f in fileset(path.module, "*.yml") : lookup(
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

output "state" {
  value = {
    roles = module.roles.debug
    users = module.users.debug
  }
}