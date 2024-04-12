### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "vault" {
  name = "vault-ec2-server"
}

resource "tfe_workspace" "tfc_poc_workspace" {
  for_each = toset(var.workspace_names)

  name         = each.value
  organization = var.TFC_ORGANIZATION_NAME
  project_id   = tfe_project.tfc_project.id

  vcs_repo {
    identifier     = var.github_repo_path
    oauth_token_id = tfe_oauth_client.vcs[each.key].oauth_token_id
  }

  file_triggers_enabled = true
  trigger_prefixes      = ["${each.value}"]
  force_delete          = false
  auto_apply            = false
  queue_all_runs        = false
  working_directory     = each.value
  global_remote_state   = true
  assessments_enabled   = true
}

data "tfe_workspace" "tfc_poc_workspace" {
  for_each = toset(var.workspace_names)

  name         = each.value
  organization = var.TFC_ORGANIZATION_NAME
  depends_on   = [tfe_workspace.tfc_poc_workspace]
}

resource "tfe_workspace_settings" "tfc_poc_workspace_settings" {
  for_each = toset(var.workspace_names)

  workspace_id   = data.tfe_workspace.tfc_poc_workspace[each.key].id
  execution_mode = "remote"
}
