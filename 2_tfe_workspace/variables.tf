variable "prefix" {
  default     = "terraform_jinsu"
  description = "prefix"
}

variable "tfc_project_name" {
  type        = string
  default     = "cloud_test"
  description = "프로젝트 명"
}

variable "workspace_names" {
  type = list(string)
  default = [
    "vpc",
    "ec2_vault_raft",
    "tfe_fdo",
    "vault_db_engine",
    "import_test"
  ]
  description = "workspace(=directory) 명 목록"
}

variable "github_repo_path" {
  type        = string
  default     = "ljinsu95/terraform_cloud"
  description = "GITHUB REPO 주소"
}

# 민감정보
## TFC ORG 명
variable "TFC_ORGANIZATION_NAME" {
  type        = string
  description = "개인 ORG 명"
}

## TFC TOKEN 값
variable "TFC_TOKEN" {
  type        = string
  description = "테라폼 토큰"
  sensitive   = true
}

## GITHUB API TOKEN 값
variable "GITHUB_API_TOKEN" {
  type        = string
  description = "GITHUB API TOKEN"
  sensitive   = true
}

## AWS ACCESS KEY
variable "AWS_ACCESS_KEY" {
  type        = string
  default     = ""
  description = "AWS ACCESS KEY"
  sensitive   = true
}

## AWS SECRET ACCESS KEY
variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  default     = ""
  description = "AWS SECRET ACCESS KEY"
  sensitive   = true
}
