locals {
  no_vpc = length(data.aws_vpcs.existing.ids) == 0 ? true : false
}