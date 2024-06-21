output "vault_public_ip" {
  value = aws_instance.vault_raft_amz2.*.public_ip
}

output "ami" {
  value = data.aws_ami.amazon_linux_2.name
}