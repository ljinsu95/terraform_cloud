provider "aws" {
  ## AWS Region
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}



## remote 실행모드 설정
## terraform login 필요
# terraform {
#   cloud {
#     organization = "insideinfo_jinsu"

#     workspaces {
#       # name = path.cwd
#       name = "ec2_vault_raft"
#     }
#   }
# }