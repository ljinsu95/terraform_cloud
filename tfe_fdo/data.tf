# data source

## 사용가능한 vpc 목록 조회
data "aws_vpcs" "existing" {}


## 사용가능한 VPC 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "selected" {
  id = data.aws_vpcs.existing.ids[0]
}

## 사용가능한 보안 그룹 목록 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups
data "aws_security_groups" "common" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

## 사용가능한 subnet 목록 조회
data "aws_subnets" "common" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

## 사용 가능한 subnet 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
data "aws_subnet" "common" {
  count = length(data.aws_subnets.common.ids)

  filter {
    name   = "subnet-id"
    values = [data.aws_subnets.common.ids[count.index]]
  }
}

## 사용 가능한 AZ 목록 조회
data "aws_availability_zones" "available" {}
