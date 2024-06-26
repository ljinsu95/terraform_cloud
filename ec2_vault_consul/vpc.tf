## Security Group
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "consul" {
  name   = "${var.prefix}_sg_consul"
  vpc_id = data.aws_vpc.selected.id

  # 22 : ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8300 : server
  # 8301 : serf lan (tcp+udp)
  # 8302 : serf wan (tcp+udp)
  ingress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8500 : http
  # 8501 : https
  # 8502 : gRPC
  # 8503 : gRPC_tls
  ingress {
    from_port   = 8500
    to_port     = 8503
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8600 : dns
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}_sg_consul"
  }
}

resource "aws_security_group" "vault_server" {
  name   = "${var.prefix}_sg_vault_server"
  vpc_id = data.aws_vpc.selected.id

  # 22 : ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8200 : vault server
  # 8201 : vault cluster 내부 통신
  ingress {
    from_port   = 8200
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8301 : consul serf lan (tcp+udp)
  # 8302 : consul serf wan (tcp+udp)
  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8500 : consul http
  # 8501 : consul https
  # 8502 : consul gRPC
  # 8503 : consul gRPC_tls
  ingress {
    from_port   = 8500
    to_port     = 8503
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}_sg_vault_server"
  }
}
