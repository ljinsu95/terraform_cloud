# AWS에서 VPC를 조회하여,
# VPC가 존재하면 기존 VPC를 사용.
# VPC가 존재하지 않는다면 Terraformd로 생성한 VPC를 사용

## vpc 워크스페이스 데이터 소스 조회
### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace
# data "tfe_workspace" "vpc" {
#   name         = path.cwd
#   organization = "insideinfo_jinsu"
# }

## vpc 목록 조회
data "aws_vpcs" "existing" {}

## vpc 조회
data "aws_vpc" "selected" {
  depends_on = [aws_vpc.main]

  state      = "available"
}

## subnet 조회
data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "name" {
  count = length(data.aws_subnets.main.ids)
  # for_each = toset(data.aws_subnets.main.ids)

  id = data.aws_subnets.main.ids[count.index]
}

output "test2" {
  value = sort(data.aws_subnet.name.*.cidr_block)
}

## az 데이터 소스 조회
data "aws_availability_zones" "available" {}


output "name" {
  value = basename(path.cwd)
}

output "name2" {
  value = path.root
}
