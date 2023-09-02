# Formats the output of a privilege module to a readable format.
locals {
  _database_schema = toset([
    for k, v in var.payload : {
      id = "${lower(v.database)}.${lower(v.schema)}"
      name = lower(v.name)
    }
  ])
  database_schema = {
    for obj in local._database_schema : obj.id => obj.name...
  }
}

output "return" {
  value = local.database_schema
}
