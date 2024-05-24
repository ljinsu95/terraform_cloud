resource "vault_namespace" "db" {
  path = var.vault_namespace
}

## Database Engine 활성화
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount
resource "vault_mount" "db" {
  namespace = vault_namespace.db.path
  path      = "database"
  type      = "database"

  depends_on = [aws_db_instance.vault]
}

## Database Connection 생성
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_connection
resource "vault_database_secret_backend_connection" "postgres" {
  count      = contains(var.db_used, "postgres") ? 1 : 0
  depends_on = [aws_db_instance.vault["postgres"]]

  plugin_name   = "postgresql-database-plugin"
  namespace     = vault_namespace.db.path
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["postgres-dynamic", "postgres-static"]

  # https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_connection#postgresql-configuration-options
  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${aws_db_instance.vault["postgres"].endpoint}/${aws_db_instance.vault["postgres"].db_name}"
    username       = var.db_info["postgres"].username
    password       = var.db_info["postgres"].password
  }
}

resource "vault_database_secret_backend_connection" "mysql" {
  count      = contains(var.db_used, "mysql") ? 1 : 0
  depends_on = [aws_db_instance.vault["mysql"]]


  plugin_name   = "mysql-database-plugin"
  namespace     = vault_namespace.db.path
  backend       = vault_mount.db.path
  name          = "mysql"
  allowed_roles = ["mysql-dynamic", "mysql-static"]

  # https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_connection#postgresql-configuration-options
  mysql {
    connection_url = "{{username}}:{{password}}@tcp(${aws_db_instance.vault["mysql"].endpoint})/${aws_db_instance.vault["mysql"].db_name}"
    username       = var.db_info["mysql"].username
    password       = var.db_info["mysql"].password
  }
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secret_backend_role
resource "vault_database_secret_backend_role" "postgres" {
  count = contains(var.db_used, "postgres") ? 1 : 0

  namespace           = vault_namespace.db.path
  backend             = vault_mount.db.path
  name                = "postgres-dynamic"
  db_name             = vault_database_secret_backend_connection.postgres.0.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
  default_ttl         = 1 * 60 * 60
  max_ttl             = 30 * 24 * 60 * 60
}

resource "vault_database_secret_backend_role" "mysql" {
  count = contains(var.db_used, "mysql") ? 1 : 0

  namespace           = vault_namespace.db.path
  backend             = vault_mount.db.path
  name                = "mysql-dynamic"
  db_name             = vault_database_secret_backend_connection.mysql.0.name
  creation_statements = ["CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';"]
  default_ttl         = 1 * 60 * 60
  max_ttl             = 30 * 24 * 60 * 60
}


