# Snowflake Role Based Access

## Terraform setup.

```bash
export SNOWFLAKE_ACCOUNT="..."
export SNOWFLAKE_USER="..."

export SNOWFLAKE_PASSWORD="..."
# OR
export SNOWFLAKE_PRIVATE_KEY_PATH="..."
export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="..."
```

Alternatives can be found
here: [Snowflake Provider](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)

### Initialise terraform.
```bash
terraform init
```

### Apply changes.
```bash
terraform apply
```

## Configuration file.
Any `.yml` file in the module root will be checked for valid configuration.
```yaml
# Roles
roles:
  role_name:
    comment: string

    privileges:
      # All resources support the following wildcard formats.
      # - database_name.*.*
      # - database_name.schema_name.*
      # - database_name.schema_partial_*.*
      # - database_name.schema_name.table_partial_*
      warehouses:
        - string

      pipes:
        - string

      stages:
        - string

      external_tables:
        - string

      tasks:
        - string

      streams:
        - string

      views:
        - string

      storage_integrations:
        - string

    # Roles have a slightly different format.
    # Exclusions are applied after inclusions and so take priority.
    # The use of wildcards is accepted anywhere in the role name.
    member_of:
      include:
        - string
      exclude:
        - string


# Users
users:
  user_name:
    can_login: boolean
    member_of:
      - string
    first_name: string
    middle_name: string
    last_name: string
    email: string
    comment: string
    default_warehouse: string
    default_namespace: string
    default_role: string
```