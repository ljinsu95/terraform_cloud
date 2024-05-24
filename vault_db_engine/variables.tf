variable "prefix" {
  default = "jinsu"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS ACCESS KEY"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS SECRET ACCESS KEY"
  sensitive   = true
}

variable "aws_region" {
  type = string
  # default = "ap-northeast-2"
  default     = "ca-central-1"
  description = "aws region"
}

variable "VAULT_ADDR" {
  type = string
  description = "Vault 서버 주소"
}
variable "VAULT_TOKEN" {
  type = string
  description = "Vault Token"
}

variable "db_used" {
  type = set(string)
  default = [
    # "postgres",
    "mysql",
  ]
}

variable "db_info" {
  description = "생성할 DB 정보"
  type = map(object(
    {
      engine         = string
      engine_version = string
      db_name        = string
      username       = string
      password       = string
    }
  ))
  default = {
    postgres = {
      engine         = "postgres"
      engine_version = "16.1"
      db_name        = "postgres"
      username       = "postgres"
      password       = "pa$$w0rd"
    },
    mysql = {
      engine         = "mysql"
      engine_version = "8.0.35"
      db_name        = ""
      username       = "admin"
      password       = "pa$$w0rd"
    },
  }
}

variable "vault_namespace" {
  description = "Vault 네임스페이스 명"
  default     = "terraform"
}
