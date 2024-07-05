output "vault_public_ip" {
  value = aws_instance.vault_consul_amz2.*.public_ip
}

output "consul_public_ip" {
  value = aws_instance.consul_amz2.*.public_ip
}

output "used_ami" {
  value = data.aws_ami.amazon_linux_2.name
}

output "security_groups_ids" {
  value = data.aws_security_groups.main.ids
}
