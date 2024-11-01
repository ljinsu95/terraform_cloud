variable "prefix" {
  default     = "terraform_eks_jinsu"
  description = "servername prefix"
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

variable "pem_key_name" {
  type        = string
  description = "ec2에 사용되는 pem key 명. 실제로 사용 될 ./file/<pem_key_name>.pem 파일 필요"
}

variable "k8s_version" {
  default     = "1.25"
  description = "k8s 버전"
}
