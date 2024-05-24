### https://registry.terraform.io/providers/hashicorp/vault/latest/docs
provider "vault" {
  address = var.VAULT_ADDR
  token = var.VAULT_TOKEN
}

### Provider
provider "aws" {
  ## AWS Region
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}