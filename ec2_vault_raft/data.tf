# 사용가능한 VPC 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "selected" {
  state = "available"
}

### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs
# data "tfe_outputs" "main" {
#   organization = "insideinfo_jinsu"
#   workspace    = "vpc"
# }

### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups
data "aws_security_groups" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_availability_zones" "available" {}

# 아마존 리눅스 2 이미지 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # filter {
  #   name   = "platform"
  #   values = ["amazon"]
  # }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}
output "ami" {
  value = data.aws_ami.amazon_linux_2.name
}
