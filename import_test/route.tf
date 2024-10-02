# VPC_ID에 속한 Route_Table 리스트 조회
data "aws_route_tables" "existing" {
  count  = length(data.aws_vpcs.existing.ids)      # VPC 갯수
  vpc_id = data.aws_vpcs.existing.ids[count.index] # VPC_IDS[count.index]의 VPC ID
}

# VPC_ID[0]의 Route_Table의 세부 정보 조회
data "aws_route_table" "existing" {
  count          = length(data.aws_route_tables.existing[0].ids)      # VPC_ID[0]에 속한 Route Table 리스트 갯수
  route_table_id = data.aws_route_tables.existing[0].ids[count.index] # ROUTE_TABLE_IDS[count.index]의 ID
}

/*
rtb-03bf56f520ee55227 - main
rtb-079e6beb839030847
rtb-087458d8f5b8fda81
rtb-0e4a118bec4626b86
*/

/*
Route Table 필요 정보
id : rtb-079e6beb839030847
routes : cidr_block :
"0.0.0.0/0"
gateway_id :
"igw-08dd9ebf7680a1486"

tags { Name = terraform-import-test }
vpc_id : vpc-0f8af692fead0eaea

Route Table Association 필요 정보
subnet-0a48ca5abc44c202c / rtb-079e6beb839030847
*/

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


