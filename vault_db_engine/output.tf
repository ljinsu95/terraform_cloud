data "aws_db_instance" "name" {
  depends_on             = [aws_db_instance.vault]
  count                  = length(keys(local.enabled_database))

  db_instance_identifier = aws_db_instance.vault[keys(local.enabled_database)[count.index]].identifier
  #   db_instance_identifier = data.aws_db_instances.example.instance_identifiers[count.index]
  #   for_each               = toset(data.aws_db_instances.example.instance_identifiers)
  #   count = length(data.aws_subnets.common.ids)

  #   tags = {
  #     RDS_GROUP = "${var.prefix}_RDS"
  #   }
}

data "aws_db_instances" "example" {
  depends_on = [aws_db_instance.vault]

#   count = tolist(local.enabled_database)

  tags = {
    RDS_GROUP = "${var.prefix}_RDS"
  }
}


output "db_endpoint" {
  value = data.aws_db_instances.example.instance_identifiers
  # value = { for s in data.aws_db_instances.example : s.identifier => s.cidr_block }
}

output "db_endpoint2" {
  value = data.aws_db_instance.name[*].address
  # value = { for s in data.aws_db_instances.example : s.identifier => s.cidr_block }
}
output "db_endpoint3" {
  value = data.aws_db_instance.name[*].address
  # value = { for s in data.aws_db_instances.example : s.identifier => s.cidr_block }
}

# output "aws_db_instance" {
#   value = aws_db_instance.vault[*].identifier
# }

output "name" {
  value = aws_instance.db_client.instance_state
}