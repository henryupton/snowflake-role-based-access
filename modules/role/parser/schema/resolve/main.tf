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
  input = {
    for k, v in coalesce(var.payload, {}) : lower(k) => {
      database = split(".", k)[0]
      schema   = split(".", k)[1]
      name     = split(".", k)[2]

      grants            = v.grants
      with_grant_option = coalesce(v.with_grant_option, false)
    }
  }

  input_wildcard = {for k, v in local.input : k => v if length(split("*", v.schema)) > 1}
  input_fqn      = {for k, v in local.input : k => v if length(split("*", v.schema)) == 1}
}

data "snowflake_schemas" "schema_wildcard" {
  for_each = local.input

  database = upper(each.value.database)
}

locals {
  _resolved_wildcards = flatten([
    for k, v in local.input_wildcard : [
      for s in coalesce(data.snowflake_schemas.schema_wildcard[k].schemas, []) : {
        database = upper(s.database)
        schema   = upper(s.name)
        name     = upper(v.name)

        grants            = v.grants
        with_grant_option = v.with_grant_option
      }
      if startswith(
        lower(s.name),
        lower(split("*", v.schema)[0])  # Match tables which share the prefix before the wildcard.
      )
    ]
  ])

  resolved_wildcards = {
    for i in local._resolved_wildcards : lower("${i.database}.${i.schema}.${i.name}") => {
      grants            = i.grants
      with_grant_option = i.with_grant_option
    }
  }

  resolved_fqns = {
    for i in local.input_fqn : lower("${i.database}.${i.schema}.${i.name}") => {
      grants            = i.grants
      with_grant_option = i.with_grant_option
    }
  }

  all_resolved = merge(
    local.resolved_wildcards,
    local.resolved_fqns,
  )
}

output "return" {
  value = local.all_resolved
}
