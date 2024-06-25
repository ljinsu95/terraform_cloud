## 인스턴스(Vault Server) 생성
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "vault_consul_amz2" {
  count = var.ec2_vault_count

  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnets.main.ids[(tonumber(count.index) + 1) % length(data.aws_subnets.main.ids)]
  security_groups = data.aws_security_groups.main.ids
  key_name        = var.pem_key_name
  tags = {
    Name    = "${var.prefix}-Vault-${count.index}"
    service = "${var.tag_name}"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = "10"
    tags = {
      Name = "${var.prefix}_Vault_Volume_${count.index}"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile = aws_iam_instance_profile.vault_join_profile.name
  user_data = templatefile(
    "userdata_vault_server.tpl",
    {
      tag_key        = "service",
      tag_value      = var.tag_name,
      vault_license  = var.VAULT_LICENSE,
      consul_license = var.CONSUL_LICENSE
    }
  )

  # lifecycle {
  #     ignore_changes = [ user_data ]
  # }
}

## 인스턴스(Consul Server) 생성
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "consul_amz2" {
  count = var.ec2_consul_count

  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnets.main.ids[(tonumber(count.index) + 1) % length(data.aws_subnets.main.ids)]
  security_groups = data.aws_security_groups.main.ids
  key_name        = var.pem_key_name
  tags = {
    Name    = "${var.prefix}-Consul-${count.index}"
    service = "${var.tag_name}"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = "10"
    tags = {
      Name = "${var.prefix}_Consul_Volume_${count.index}"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile = aws_iam_instance_profile.vault_join_profile.name

  # user_data = data.template_file.user_data.rendered
  user_data = templatefile(
    "userdata_consul_server.tpl",
    {
      tag_key        = "service"
      tag_value      = var.tag_name
      vault_license  = var.VAULT_LICENSE
      consul_license = var.CONSUL_LICENSE
    }
  )

  # lifecycle {
  #     ignore_changes = [ user_data ]
  # }
}
