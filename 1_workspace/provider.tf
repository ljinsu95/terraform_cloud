provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.TFC_ORGANIZATION_NAME
  token        = var.TFC_TOKEN
}