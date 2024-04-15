## vpc 워크스페이스 데이터 소스 조회
### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace
data "tfe_workspace" "vpc" {
  name         = path.cwd
  organization = "insideinfo_jinsu"
}

## vpc 워크스페이스에 aws region 변수 추가
### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "aws_region" {
  key          = "aws_region"
  value        = ""
  category     = "terraform"
  sensitive    = false
  workspace_id = data.tfe_workspace.vpc.id
  description  = "aws_region"
}
