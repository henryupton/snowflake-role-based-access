# Fully qualified names (no wildcards) bypass the matching.
# This avoids matching 'abcd' when the fqn 'abc' is provided.
locals {
  fqn = {for k, v in var.payload : k => v if length(split("*", k)) == 1}

  payload = {for k, v in var.payload : k => v if length(split("*", k)) > 1}
}

# Module to simply parse the FQN and return the output to the next level of the equation.
locals {
  resolved_fqns = flatten([
    for k, v in local.fqn : [
      for t in var.candidates : [
        for g in v.grants : {
          database = upper(v.database)
          schema   = upper(v.schema)
          name     = upper(v.name)

          fqn = upper("${v.database}.${v.schema}.${v.name}")

          pattern_matched = k

          grant             = g
          with_grant_option = v.with_grant_option
        }
        if lower(t.database) == lower(v.database)
        && lower(t.schema) == lower(v.schema)
        && lower(t.name) == lower(v.name)
      ]
    ]
  ])

  resolved_wildcards = flatten([
    for k, v in local.payload : [
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

  objects_by_grant = merge(
    {
      for i in local.resolved_wildcards : lower("${i.fqn}|${i.grant}") => i
    },
    {
      for i in local.resolved_fqns : lower("${i.fqn}|${i.grant}") => i
    },
  )
}

output "return" {
  value = local.objects_by_grant
}
