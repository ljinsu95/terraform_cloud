data "aws_availability_zones" "available" {
#   state = "available"
    
}

output "name" {
  value = data.aws_availability_zones.available.names
}