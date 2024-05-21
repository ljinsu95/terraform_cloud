output "az_name_list" {
  value = data.aws_availability_zones.available.names
}

## vpc id 출력
output "vpc_id" {
  value = aws_vpc.main.id
  description = "main vpc id"
}

output "TFC_ORGANIZATION_NAME" {
  value = var.TFC_ORGANIZATION_NAME
}