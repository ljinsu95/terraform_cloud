output "vault_public_ip" {
  value = aws_instance.vault_raft_amz2.*.public_ip
}

output "ami" {
  value = data.aws_ami.amazon_linux_2.name
}

output "vault_raft_amz2" {
  value = <<-EOF
  import {
    to = aws_instance.vault_raft_amz2
    id = "${aws_instance.vault_raft_amz2[0].arn}"
  }
  EOF
}