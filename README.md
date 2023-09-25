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
      # All schema resources support the following wildcard formats.
      # - database_name.*.*
      # - database_name.schema_name.*
      # - database_name.schema_partial_*.*
      # - database_name.schema_name.object_partial_*
      # - database_name.schema_name.object_name
      external_tables:
        string:
          grants:
            - string

      file_formats:
        ...
      functions:
        ...
      masking_policies:
        ...
      materialized_views:
        ...
      pipes:
        ...
      procedures:
        ...
      sequences:
        ...
      stages:
        ...
      streams:
        ...
      tables:
        ...
      tasks:
        ...
      views:
        ...
      # All account resources support only fully qualified references.
      # - object_name
      storage_integrations:
        string:
          grants:
            - string

      warehouses:
        ...
      
    # Roles have a slightly different format.
    # Exclusions are applied after inclusions and so take priority.
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
    last_name: string
    email: string
    comment: string
    default_warehouse: string
    default_namespace: string
    default_role: string
```

## Limitations.
Case-sensitive object names are not supported. All identifiers are converted
to upper case in align with [Snowflake's recommendations](https://docs.snowflake.com/en/sql-reference/identifiers-syntax). 