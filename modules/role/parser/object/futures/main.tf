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

  futures_by_grant = {
    for i in local.futures : lower("${i.database}.${i.schema}|${join("|", i.grants)}") => i
  }
}

output "return" {
  value = local.futures_by_grant
}
