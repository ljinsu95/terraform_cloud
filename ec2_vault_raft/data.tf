## 사용가능한 vpc 목록 조회
data "aws_vpcs" "existing" {}

## 사용가능한 VPC 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "selected" {
  id = data.aws_vpcs.existing.ids[0]
}

## 서브넷 리스트 조회
data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
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
# 아마존 리눅스 2023 이미지 조회
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # filter {
  #   name   = "image-id"
  #   values = ["ami-038aeeeeed95c7942"]
  # }

  filter {
    name   = "name"
    values = ["al2023-ami-2023.6*"]
  }
}
