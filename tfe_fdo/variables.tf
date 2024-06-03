variable "prefix" {
  type = string
  default     = "jinsu-tfe-fdo"
  description = "prefix"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "AWS ACCESS KEY"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "AWS SECRET ACCESS KEY"
  sensitive   = true
}

variable "TFE_FDO_LICENSE" {
  type = string
  description = "TFE License"
  sensitive   = true
}

variable "aws_region" {
  type = string
  default     = "ca-central-1"
  description = "aws region"
}

variable "aws_hostingzone" {
  default     = "inside-vault.com"
  description = "AWS Route 53에 등록된 호스팅 영역 명"
}

variable "pem_key_name" {
  default     = "jinsu"
  description = "AWS PEM KEY 명"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  # default     = "t3.micro"
  description = "x86 instance type"
}

variable "architecture" {
  type = string
  # default     = "arm"
  default     = "x86"
  description = "ec2에 사용되는 아키텍쳐 명"
}
