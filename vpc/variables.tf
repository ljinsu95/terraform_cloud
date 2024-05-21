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
  description = "개인 ORG 명"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS ACCESS KEY"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS SECRET ACCESS KEY"
  sensitive   = true
}

variable "aws_region" {
  default     = "ca-central-1"
  # default     = "ap-northeast-2"
  description = "aws region"
}

variable "aws_vpc_cidr" {
  default     = "172.170.0.0/16"
  description = "AWS VPC CIDR"
}

variable "pem_key_name" {
  default     = "jinsu"
  description = "AWS PEM KEY 명"
}
