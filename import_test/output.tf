# # VPC 리스트 확인
# output "check_vpcs" {
#   value = data.aws_vpcs.existing
# }

# # VPC 확인
# output "check_vpc" {
#   value = data.aws_vpc.existing
# }

# VPC_ID에 속한 Route_Table 리스트 조회
output "check_route_tables" {
  value = data.aws_route_tables.existing
}

# VPC_ID[0]의 Route_Table의 세부 정보 조회
output "check_route_table" {
  value = data.aws_route_table.existing
}

# # output "Nameasd" {
# #   value = tolist(data.aws_route_table.existing[*].tags)[0].Name
# # }
# # output "Nameasd" {
# #   value = local.route
# # }
# output "check_route_id" {
#   value = local.route_map
# }


