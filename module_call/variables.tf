variable "prefix" {
  default     = "tf_jinsu_module_call"
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
  description = "ec2에 사용되는 pem key 명."
}
