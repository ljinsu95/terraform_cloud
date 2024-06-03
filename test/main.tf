

# VPC 조회
data "aws_vpcs" "existing" {}

data "aws_vpc" "existing" {
  depends_on = [aws_vpc.new_vpc]

  filter {
    name   = "vpc-id"
    values = [length(data.aws_vpcs.existing.ids) > 0 ? data.aws_vpcs.existing.ids[0] : aws_vpc.new_vpc[0].id]
  }
}

# 새로운 VPC 생성
resource "aws_vpc" "new_vpc" {
  count = length(data.aws_vpcs.existing.ids) == 0 ? 1 : 0

  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# VPC ID 출력
output "vpc_id" {
  value = data.aws_vpc.existing.cidr_block
}
