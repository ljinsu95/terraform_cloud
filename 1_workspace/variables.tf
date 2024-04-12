variable "prefix" {
  default     = "terraform_jinsu"
  description = "prefix"
}

variable "TFC_TOKEN" {
  type        = string
  description = "테라폼 토큰"
  sensitive   = true
}

variable "TFC_ORGANIZATION_NAME" {
  type        = string
  description = "개인 ORG 명F"
}

variable "tfc_project_name" {
  type        = string
  default     = "cloud_test"
  description = "프로젝트 명"
}

variable "GITHUB_API_TOKEN" {
  type        = string
  description = "GITHUB API TOKEN"
  sensitive   = true
}

variable "workspace_names" {
  type        = list(string)
  default     = ["vpc", "ec2_vault"]
  description = "workspace(=directory) 명 목록"
}

variable "github_repo_path" {
  type        = string
  default     = "ljinsu95/terraform_cloud"
  description = "GITHUB REPO 주소"
}
