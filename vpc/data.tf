## vpc 워크스페이스 데이터 소스 조회
### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace
# data "tfe_workspace" "vpc" {
#   name         = path.cwd
#   organization = "insideinfo_jinsu"
# }

## az 데이터 소스 조회
data "aws_availability_zones" "available" {}


output "name" {
  value = basename(path.cwd)
}

output "name2" {
  value = path.root
}
