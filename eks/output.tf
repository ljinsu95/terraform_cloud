# output "subnets" {
#   value = data.aws_subnets.existing
# }

output "eks_controller" {
  value = aws_instance.eks_controller.public_ip
}