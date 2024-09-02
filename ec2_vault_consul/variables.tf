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

variable "ec2_vault_count" {
  default     = 1
  description = "EC2 vault 갯수 설정"
}

variable "ec2_consul_count" {
  default     = 3
  description = "EC2 consul 갯수 설정"
}

variable "tag_name" {
  type        = string
  default     = "consul_auto_join"
  description = "consul_auto_join을 위한 태그 명"
}

variable "VAULT_LICENSE" {
  type        = string
  description = "License for the Vault"
  sensitive   = true

}

variable "CONSUL_LICENSE" {
  type        = string
  description = "License for the Consul"
  sensitive   = true

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
