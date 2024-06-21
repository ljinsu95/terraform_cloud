data "vault_kv_secret_v2" "data" {
#   namespace = ""
  mount = "kv-v2"
  name = "test"
}

output "kv-value" {
  value = data.vault_kv_secret_v2.data.path
#   sensitive = true
}

# namespace 생성
resource "vault_namespace" "main" {
  path = "terraform"
}