# VPC 리스트 조회
data "aws_vpcs" "existing" {}

# # VPC 조회
# data "aws_vpc" "existing" {
#   count = length(data.aws_vpcs.existing.ids)
#   id    = data.aws_vpcs.existing.ids[count.index]
# }
