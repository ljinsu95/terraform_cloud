terraform {
  cloud {
    hostname     = "terraform.insideinfo-cloud.com"
    organization = "insideinfo"
    workspaces {
      name = "app"
    }
  }
}
