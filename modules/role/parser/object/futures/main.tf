# Module to find any FQN which ends in a wildcard and put it aside.
locals {
  # Only grant futures on entire schemas.
  futures = {
    for k, v in var.payload : "${v.database}.${v.schema}" => {
      database = upper(v.database)
      schema   = upper(v.schema)

      grants            = v.grants
      with_grant_option = v.with_grant_option
    } if v.name == "*"
  }

  _futures_by_grant = flatten([
    for k, v in local.futures : [
      for g in v.grants : {
        database = v.database
        schema   = v.schema

        grant             = g
        with_grant_option = v.with_grant_option
      }
    ]
  ])

  futures_by_grant = {
    for i in local._futures_by_grant : lower("${i.database}.${i.schema}|${i.grant}") => i
  }
}

output "return" {
  value = local.futures_by_grant
}
