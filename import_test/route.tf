data "aws_route_tables" "existing" {
  count  = length(data.aws_vpcs.existing.ids)
  vpc_id = data.aws_vpcs.existing.ids[count.index]
}

data "aws_route_table" "existing" {
  count          = length(data.aws_route_tables.existing[0].ids)
  route_table_id = data.aws_route_tables.existing[0].ids[count.index]
}

/*
rtb-03bf56f520ee55227 - main
rtb-079e6beb839030847
rtb-087458d8f5b8fda81
rtb-0e4a118bec4626b86
*/

import {
  id = "rtb-079e6beb839030847"
  to = aws_route_table.terraform-import-test
}

resource "aws_route_table" "terraform-import-test" {
  vpc_id = "vpc-0f8af692fead0eaea"
  tags = {
    "Name" = "terraform-import-test"
  }
}

import {
  id = "subnet-0c47e5a32380dfac3/${aws_route_table.terraform-import-test.id}"
  to = aws_route_table_association.terraform-import-test-1
}

resource "aws_route_table_association" "terraform-import-test-1" {
  route_table_id = aws_route_table.terraform-import-test.id
  subnet_id      = "subnet-0c47e5a32380dfac3"
}

import {
  id = "subnet-0a48ca5abc44c202c/${aws_route_table.terraform-import-test.id}"
  to = aws_route_table_association.terraform-import-test-2
}

resource "aws_route_table_association" "terraform-import-test-2" {
  route_table_id = aws_route_table.terraform-import-test.id
  subnet_id      = "subnet-0a48ca5abc44c202c"
}


