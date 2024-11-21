provider "aws" {
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

terraform {
  # remote 실행모드 설정 (로컬에서 실행 시 terraform login 필요)
  cloud {
    # hostname     = "jinsu.terraform.insideinfo-cloud.com"
    # organization = "insideinfo"
    hostname     = "app.terraform.io"
    organization = "insideinfo_jinsu"

    workspaces {
      name = "ec2_vault_raft"
    }
  }

  required_providers {
    # AWS Provider Version 설정
    aws = {
      version = ">=5.70.0"
    }
  }
}
