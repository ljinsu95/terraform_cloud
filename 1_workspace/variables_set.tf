### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set
resource "tfe_variable_set" "org_variable_set" {
  name = "${var.prefix}_var_set"
}

### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project_variable_set
resource "tfe_project_variable_set" "tfc_poc_project_org_var_set" {
  variable_set_id = tfe_variable_set.org_variable_set.id
  project_id      = tfe_project.tfc_project.id
}

### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "tfc_poc_1_1_workspace_name" {
  key             = "TFC_1_1_WORKSPACE_NAME"
  value           = "1-1_vcs"
  sensitive       = false
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}

resource "tfe_variable" "TFC_TOKEN" {
  key             = "TFC_TOKEN"
  value           = var.TFC_TOKEN  # 개인 TFC_TOKEN
  sensitive       = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}

resource "tfe_variable" "aws_access_key" {
  key             = "AWS_ACCESS_KEY_ID"
  value           = ""  # 개인 AWS Access Key 입력
  sensitive       = false
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}

resource "tfe_variable" "aws_secret_key" {
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = "" # 개인 AWS Secret Key 입력
  sensitive       = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}

resource "tfe_variable" "vault_license" {
  key             = "VAULT_LICENSE"
  value           = "" # VAULT_LICENSE 입력
  sensitive       = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}

resource "tfe_variable" "vault_token" {
  key             = "VAULT_TOKEN"
  value           = "" # VAULT_TOKEN 입력
  sensitive       = true
  category        = "terraform"
  variable_set_id = tfe_variable_set.org_variable_set.id
}