output "az_name_list" {
  value = data.aws_availability_zones.available.names
}

## vpc id 출력
output "vpc_id" {
  value = data.aws_vpc.selected.id

  description = "main vpc id"
}

output "TFC_ORGANIZATION_NAME" {
  value = var.TFC_ORGANIZATION_NAME
}

output "cidr" {
  value = data.aws_vpc.selected.cidr_block
}

output "subnet" {
  value = data.aws_subnets.main.ids
}

