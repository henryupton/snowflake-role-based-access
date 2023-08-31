module "grants" {
  source = "./modules/roles"

  # Read all yaml files in this dir.
  roles = merge(
        [
          for f in fileset(path.module, "*.yml") : lookup(
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

output "debug" {
  value = module.grants.debug
}