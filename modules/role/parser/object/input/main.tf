# Module to simply parse the FQN and return the output to the next level of the equation.
locals {
  input = {
    for k, v in coalesce(var.payload, {}) : lower(k) => {
      database = split(".", k)[0]
      schema   = split(".", k)[1]
      name     = split(".", k)[2]

      grants            = [for grant in v.grants : upper(grant)]
      with_grant_option = coalesce(v.with_grant_option, false)
    }
  }
}

output "return" {
  value = local.input
}
