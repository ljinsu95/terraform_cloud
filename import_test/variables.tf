variable "prefix" {
  type = string
  default     = "jinsu-tfe-fdo"
  description = "prefix [a-z][A-Z][0-9][-]"
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

variable "aws_region" {
  type = string
  default     = "ca-central-1"
  description = "aws region"
}