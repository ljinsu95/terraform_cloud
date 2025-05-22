# main.tf
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name = "my-ec2-instance"

  instance_type          = "t3.micro"
  key_name               = var.pem_key_name # 기존 키 페어 이름
  monitoring             = true
  vpc_security_group_ids = ["sg-0214d6da750d88d45"]   # 기존 보안 그룹 ID
  subnet_id              = "subnet-052b5eae8cc4f2515" # 기존 서브넷 ID

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
