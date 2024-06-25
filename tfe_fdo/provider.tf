### Provider
provider "aws" {
  ## AWS Region
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}


# remote 실행모드 설정
# terraform login 혹은 terraform token 환경변수 필요 TF_TOKEN_app_terraform_io=<YOUR_TERRAFORM_API_TOKEN>
terraform {
  cloud {
    organization = "insideinfo_jinsu"

    workspaces {
      name = "tfe_fdo"
    }
  }
}
