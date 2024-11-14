module "vault" {
  source                = "jinsu.terraform.insideinfo-cloud.com/insideinfo/vault-server/aws"
  version               = "1.0.7"
  AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  VAULT_LICENSE         = var.VAULT_LICENSE
  prefix                = var.prefix
  aws_region            = var.aws_region
  ec2_vault_servers     = var.ec2_vault_servers
  ec2_consul_servers    = var.ec2_consul_servers
  ec2_instance_type     = var.ec2_instance_type
  ec2_architecture      = var.ec2_architecture
  ec2_pem_key_name      = var.ec2_pem_key_name
  vault_storage_mode    = var.vault_storage_mode
  aws_subnets_ids       = null
}
