# output "vpcs" {
#   value = data.aws_vpcs.existing
# }
# output "vpc" {
#   value = data.aws_vpc.existing
# }

# output "route_tables" {
#   value = data.aws_route_tables.existing
# }
output "route_table" {
  value = data.aws_route_table.existing
}
# output "Nameasd" {
#   value = tolist(data.aws_route_table.existing[*].tags)[0].Name
# }
# output "Nameasd" {
#   value = local.route
# }
output "bbbbbbbbbbbbbbb" {
  value = local.route_map
}
