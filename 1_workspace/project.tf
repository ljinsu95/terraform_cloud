resource "tfe_project" "tfc_project" {
  organization = var.TFC_ORGANIZATION_NAME
  name         = var.tfc_project_name
}