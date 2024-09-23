data "aws_route_tables" "existing" {
  count  = length(data.aws_vpcs.existing.ids)
  vpc_id = data.aws_vpcs.existing.ids[count.index]
}

data "aws_route_table" "existing" {
  count          = length(data.aws_route_tables.existing[0].ids)
  route_table_id = data.aws_route_tables.existing[0].ids[count.index]
}
