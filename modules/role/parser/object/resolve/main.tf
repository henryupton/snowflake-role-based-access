# Module to simply parse the FQN and return the output to the next level of the equation.
terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.66.1"
      configuration_aliases = [
        snowflake,
      ]
    }
  }
}

locals {
  resolved_wildcards = flatten([
    for k, v in var.payload : [
      for t in var.candidates : [
        for g in v.grants : {
          database = upper(t.database)
          schema   = upper(t.schema)
          name     = upper(t.name)

          fqn = upper("${t.database}.${t.schema}.${t.name}")

          pattern_matched = k

          grant             = g
          with_grant_option = v.with_grant_option
        }
        if startswith(
          lower(t.name),
          lower(split("*", v.name)[0])  # Match tables which share the prefix before the wildcard.
        )
        && lower(t.schema) == lower(v.schema)  # Don't want to match across schemas.
      ]
    ]
  ])

  objects_by_grant = {
    for i in local.resolved_wildcards : lower("${i.database}.${i.schema}.${i.name}|${i.grant}") => i
  }
}

output "return" {
  value = local.objects_by_grant
}
