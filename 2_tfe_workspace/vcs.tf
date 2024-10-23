resource "tfe_oauth_client" "vcs" {
  for_each         = toset(var.workspace_names)

  name             = each.value
  organization     = var.TFC_ORGANIZATION_NAME
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.GITHUB_API_TOKEN
  service_provider = "github"
}
