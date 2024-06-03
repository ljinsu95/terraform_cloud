data "vault_kv_secret_v2" "data" {
#   namespace = ""
  mount = "kv-v2"
  name = "test"
}

output "kv-value" {
  value = data.vault_kv_secret_v2.data.path
#   sensitive = true
}
