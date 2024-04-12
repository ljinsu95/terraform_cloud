data "aws_availability_zones" "available" {
#   state = "available"
    
}

output "az_name_list" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = aws_vpc.main.id
  description = "main vpc id"
  depends_on = [ tfe_workspace_run.vault_destroy ]
}