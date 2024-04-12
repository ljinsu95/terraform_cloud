### https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "vault" {
  name         = "vault-ec2-server"
#   organization = tfe_organization.test-organization.name
#   tag_names    = ["test", "app"]
}

resource "tfe_workspace_run" "vault_destroy" {
  workspace_id = tfe_workspace.vault.id

  destroy {
    manual_confirm = false
  }

  depends_on = [ data.tfe_workspace.main ]
}

resource "tfe_run_trigger" "name" {
  sourceable_id = tfe_workspace.vault.id
  workspace_id = data.tfe_workspace.main.id
}