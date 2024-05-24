# data source

## 사용가능한 VPC 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "selected" {
  state = "available"
  # id = "1"
}

## 
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups
data "aws_security_groups" "common" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

## subnet 조회
data "aws_subnets" "common" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
data "aws_subnet" "common" {
  count = length(data.aws_subnets.common.ids)

  filter {
    name   = "subnet-id"
    values = [data.aws_subnets.common.ids[count.index]]
  }
}

data "aws_availability_zones" "available" {}

output "aws_subnet_select" {
  value = data.aws_vpc.selected
}