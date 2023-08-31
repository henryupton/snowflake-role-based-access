# Module remove duplicates from a map base on both key and value.
locals {
  objects_in_pattern = {
    for object_pattern, object_map in var.payload : object_pattern => object_map.return
    if length(object_map.return) > 0
  }

  flat_objects = toset(  # This is important as it allows overlap between the wildcards resulting in an OR like behavior.
    flatten(
      [
        for object_pattern, object_map in local.objects_in_pattern : [
        for k, v in object_map : {
          key      = k
          database = v.database
          schema   = v.schema
          name     = v.name

          grant             = v.grant
          with_grant_option = v.with_grant_option
        }
      ]
      ]
    )
  )

  flat_object_map = {
    for obj in local.flat_objects : obj.key => {
      database = obj.database
      schema   = obj.schema
      name     = obj.name

      grant             = obj.grant
      with_grant_option = obj.with_grant_option
    }
  }
}

output "return" {
  value = local.flat_object_map
}
