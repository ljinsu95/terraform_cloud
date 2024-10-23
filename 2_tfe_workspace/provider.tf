provider "tfe" {
  hostname     = "jinsu.terraform.insideinfo-cloud.com"
  organization = var.TFC_ORGANIZATION_NAME
  token        = var.TFC_TOKEN
}