provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.TFC_ORGANIZATION_NAME
  token        = var.TFC_TOKEN
}

provider "aws" {
  ## AWS Region
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

## Local 실행모드 설정
## terraform login 필요
terraform {
  cloud {
    organization = "insideinfo_jinsu"

    workspaces {
      name = "vpc"
    }
  }
}
