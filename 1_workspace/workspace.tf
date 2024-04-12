### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "vault" {
  name = "vault-ec2-server"
}

resource "tfe_workspace" "tfc_poc_workspace" {
  name         = "main"
  organization = var.TFC_ORGANIZATION_NAME
  project_id   = tfe_project.tfc_project.id
  vcs_repo {
    identifier     = "ljinsu95/terraform_cloud"
    oauth_token_id = tfe_oauth_client.vcs.oauth_token_id
  }
  file_triggers_enabled = true
  trigger_prefixes      = ["main"]
  force_delete          = false
  auto_apply            = false
  queue_all_runs        = false
  working_directory     = "main"
  global_remote_state   = true
  assessments_enabled   = true
}

resource "tfe_workspace_settings" "tfc_poc_workspace_settings" {
  workspace_id   = tfe_workspace.tfc_poc_workspace.id
  execution_mode = "remote"
}
