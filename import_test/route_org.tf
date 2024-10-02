# Route Table Improt
import {
  id = "rtb-079e6beb839030847"               # ROUTE_TABLE_ID
  to = aws_route_table.terraform-import-test # ROUTE_TABLE Import Target
}

# ROUTE_TABLE Import Target
resource "aws_route_table" "terraform-import-test" {
  vpc_id = "vpc-0f8af692fead0eaea"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-08dd9ebf7680a1486"
  }

  tags = {
    "Name" = "terraform-import-test"
  }
}

# Route Table Association Import 1
import {
  id = "subnet-0c47e5a32380dfac3/rtb-079e6beb839030847"    # SUBNET_ID/ROUTE_TABLE_ID 
  to = aws_route_table_association.terraform-import-test-1 # ROUTE_TABLE_ADDOCIATION Import Target 1
}

# ROUTE_TABLE_ADDOCIATION Import Target 1
resource "aws_route_table_association" "terraform-import-test-1" {
  route_table_id = "rtb-079e6beb839030847"
  subnet_id      = "subnet-0c47e5a32380dfac3"
}

# Route Table Association Import 2
import {
  id = "subnet-0a48ca5abc44c202c/${aws_route_table.terraform-import-test.id}" # SUBNET_ID/ROUTE_TABLE_ID 
  to = aws_route_table_association.terraform-import-test-2                    # ROUTE_TABLE_ADDOCIATION Import Target 1
}

# ROUTE_TABLE_ADDOCIATION Import Target 1
resource "aws_route_table_association" "terraform-import-test-2" {
  route_table_id = aws_route_table.terraform-import-test.id
  subnet_id      = "subnet-0a48ca5abc44c202c"
}