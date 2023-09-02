locals {
  snowflake_account      = "<SNOWFLAKE_ACCOUNT>"
  snowflake_username     = "<SNOWFLAKE_USER>"
}

terraform {
  required_version = ">1.3.2"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.66.1"
    }
  }
}

provider "snowflake" {
  account  = local.snowflake_account
  username = local.snowflake_username
  role     = "SYSADMIN"
}

provider "snowflake" {
  account  = local.snowflake_account
  username = local.snowflake_username
  role     = "USERADMIN"
  alias    = "useradmin"
}

provider "snowflake" {
  account  = local.snowflake_account
  username = local.snowflake_username
  role     = "SECURITYADMIN"
  alias    = "securityadmin"
}
