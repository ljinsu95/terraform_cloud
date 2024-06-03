### https://registry.terraform.io/providers/hashicorp/vault/latest/docs
provider "vault" {
  address = "https://jinsu.inside-vault.com"
  token = var.VAULT_TOKEN
}