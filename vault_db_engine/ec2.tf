## 인스턴스(DB_Client) 생성
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "db_client" {
  depends_on = [aws_db_instance.vault]

  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t3.micro"
  subnet_id       = data.aws_subnets.common.id
  security_groups = data.aws_security_groups.common.ids
  tags = {
    Name = "${var.prefix}-db-client"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = "10"
    tags = {
      Name = "${var.prefix}_db_client_Volume"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = templatefile(
    "user_data.tpl",
    {
      ENABLE_POSTGRESQL = var.db_info.postgres.used
      ENABLE_MYSQL      = var.db_info.mysql.used
      PGUSER            = var.db_info.postgres.used ? aws_db_instance.vault["postgres"].username : ""
      PGPASSWORD        = var.db_info.postgres.used ? aws_db_instance.vault["postgres"].password : ""
      PGHOSTNAME        = var.db_info.postgres.used ? aws_db_instance.vault["postgres"].address : ""
      PGDBNAME          = var.db_info.postgres.used ? aws_db_instance.vault["postgres"].db_name : ""
      MYSQL_USER        = var.db_info.mysql.used ? aws_db_instance.vault["mysql"].username : ""
      MYSQL_PWD         = var.db_info.mysql.used ? aws_db_instance.vault["mysql"].password : ""
      MYSQL_HOSTNAME    = var.db_info.mysql.used ? aws_db_instance.vault["mysql"].address : ""
      MYSQL_DBNAME      = var.db_info.mysql.used ? ws_db_instance.vault["mysql"].db_name : ""
    }
  )
}
