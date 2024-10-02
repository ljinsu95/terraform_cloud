# VPC 리스트 확인
output "check_vpcs" {
  value = data.aws_vpcs.existing
}

# VPC 확인
output "check_vpc" {
  value = data.aws_vpc.existing
}

# 모든 VPC에 대한 Route Table 리스트 조회
output "check_route_tables" {
  value = data.aws_route_tables.existing
}

# VPC 별 모든 Route Table 조회
output "check_route_table" {
  value = data.aws_route_table.existing
}
# output "Nameasd" {
#   value = tolist(data.aws_route_table.existing[*].tags)[0].Name
# }
# output "Nameasd" {
#   value = local.route
# }
output "check_route_id" {
  value = local.route_map
}


