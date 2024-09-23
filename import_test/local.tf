locals {
  #   for_each = tolist(data.aws_route_table.existing[*].tags)[*]
  #   test     = each.value.Name

  #   route    = tolist(data.aws_route_table.existing[*].tags)[*]

  route_map = {
    for obj in data.aws_route_table.existing : obj.route_table_id => {
      Name           = lookup(obj.tags, "Name", "" )
    #   Name           = type() obj.tags? obj.tags.Name : ""
      route_table_id = obj.route_table_id
    }
  }
}
