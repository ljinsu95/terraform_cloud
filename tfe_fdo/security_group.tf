## Security Group
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "all" {
  name   = "${var.prefix}-All-allowed-fdo"
  vpc_id = data.aws_vpc.selected.id
#   vpc_id = aws_vpc.fdo.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-All-allowed-fdo"
  }
}