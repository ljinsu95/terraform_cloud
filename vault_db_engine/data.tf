## vpc 목록 조회
data "aws_vpcs" "existing" {}

output "vpcs" {
  value = data.aws_vpcs.existing
}

## vpc 조회
data "aws_vpc" "selected" {
  id    = data.aws_vpcs.existing.ids.0
  state = "available"
}

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


data "aws_db_instances" "name" {}
# data "aws_db_instance" "name" {
#   db_instance_identifier = data.aws_db_instances.name.instance_identifiers.1
# }

# output "db_list" {
#   value = data.aws_db_instance.name
# }

# 아마존 리눅스 2 이미지 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}
