variable "prefix" {
  default     = "terraform_jinsu"
  description = "prefix"
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
  description = "aws region"
}

variable "ec2_count" {
  default     = 3
  description = "EC2 갯수 설정"
}

variable "tag_name" {
  type        = string
  default     = "vault_auto_join_0926"
  description = "vault_auto_join을 위한 태그 명"
}

variable "VAULT_LICENSE" {
  type        = string
  sensitive   = true
  description = "License for the Vault"
  # default    = "YOUR_DEFAULT_VALUE" # 필요한 경우 기본값 설정 
}

variable "pem_key_name" {
  type        = string
  default     = "jinsu"
  description = "ec2에 사용되는 pem key 명"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "x86 instance type"
}

variable "architecture" {
  type = string
  # default     = "arm"
  default     = "x86"
  description = "ec2에 사용되는 아키텍쳐 명"
}

