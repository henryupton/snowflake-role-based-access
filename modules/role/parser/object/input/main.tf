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
    for k, v in var.payload : lower(k) => {
      database = split(".", k)[0]
      schema   = split(".", k)[1]
      name     = split(".", k)[2]

      grants            = v.grants
      with_grant_option = coalesce(v.with_grant_option, false)
    }
  }
}

output "return" {
  value = local.input
}
