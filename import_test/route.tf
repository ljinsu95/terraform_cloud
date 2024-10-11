# # VPC_ID에 속한 Route_Table 리스트 조회
# data "aws_route_tables" "existing" {
#   count  = length(data.aws_vpcs.existing.ids)      # VPC 갯수
#   vpc_id = data.aws_vpcs.existing.ids[count.index] # VPC_IDS[count.index]의 VPC ID
# }

# # VPC_ID[0]의 Route_Table의 세부 정보 조회
# data "aws_route_table" "existing" {
#   count          = length(data.aws_route_tables.existing[0].ids)      # VPC_ID[0]에 속한 Route Table 리스트 갯수
#   route_table_id = data.aws_route_tables.existing[0].ids[count.index] # ROUTE_TABLE_IDS[count.index]의 ID
# }

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

# # Route Table Improt
# import {
#   id = "rtb-079e6beb839030847"               # ROUTE_TABLE_ID
#   to = aws_route_table.terraform-import-test # ROUTE_TABLE Import Target
# }

# # ROUTE_TABLE Import Target
# resource "aws_route_table" "terraform-import-test" {
#   vpc_id = "vpc-0f8af692fead0eaea"

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "igw-08dd9ebf7680a1486"
#   }

#   tags = {
#     "Name" = "terraform-import-test"
#   }
# }

# # Route Table Association Import 1
# import {
#   id = "subnet-0c47e5a32380dfac3/rtb-079e6beb839030847"    # SUBNET_ID/ROUTE_TABLE_ID 
#   to = aws_route_table_association.terraform-import-test-1 # ROUTE_TABLE_ADDOCIATION Import Target 1
# }

# # ROUTE_TABLE_ADDOCIATION Import Target 1
# resource "aws_route_table_association" "terraform-import-test-1" {
#   route_table_id = "rtb-079e6beb839030847"
#   subnet_id      = "subnet-0c47e5a32380dfac3"
# }

# # Route Table Association Import 2
# import {
#   id = "subnet-0a48ca5abc44c202c/${aws_route_table.terraform-import-test.id}" # SUBNET_ID/ROUTE_TABLE_ID 
#   to = aws_route_table_association.terraform-import-test-2                    # ROUTE_TABLE_ADDOCIATION Import Target 1
# }

# # ROUTE_TABLE_ADDOCIATION Import Target 1
# resource "aws_route_table_association" "terraform-import-test-2" {
#   route_table_id = aws_route_table.terraform-import-test.id
#   subnet_id      = "subnet-0a48ca5abc44c202c"
# }


# check_route_table = [
#   {
#     "arn" = "arn:aws:ec2:ca-central-1:421448405988:route-table/rtb-0e4a118bec4626b86"
#     "associations" = tolist([])
#     "filter" = toset(null) /* of object */
#     "gateway_id" = tostring(null)
#     "id" = "rtb-0e4a118bec4626b86"
#     "owner_id" = "421448405988"
#     "route_table_id" = "rtb-0e4a118bec4626b86"
#     "routes" = tolist([
#       {
#         "carrier_gateway_id" = ""
#         "cidr_block" = "0.0.0.0/0"
#         "core_network_arn" = ""
#         "destination_prefix_list_id" = ""
#         "egress_only_gateway_id" = ""
#         "gateway_id" = "igw-08dd9ebf7680a1486"
#         "instance_id" = ""
#         "ipv6_cidr_block" = ""
#         "local_gateway_id" = ""
#         "nat_gateway_id" = ""
#         "network_interface_id" = ""
#         "transit_gateway_id" = ""
#         "vpc_endpoint_id" = ""
#         "vpc_peering_connection_id" = ""
#       },
#     ])
#     "subnet_id" = tostring(null)
#     "tags" = tomap({
#       "Name" = "igw-route-test"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-0f8af692fead0eaea"
#   },
#   {
#     "arn" = "arn:aws:ec2:ca-central-1:421448405988:route-table/rtb-087458d8f5b8fda81"
#     "associations" = tolist([
#       {
#         "gateway_id" = ""
#         "main" = false
#         "route_table_association_id" = "rtbassoc-05f9da3c5cec01fa5"
#         "route_table_id" = "rtb-087458d8f5b8fda81"
#         "subnet_id" = "subnet-0228da92536dfaf67"
#       },
#     ])
#     "filter" = toset(null) /* of object */
#     "gateway_id" = tostring(null)
#     "id" = "rtb-087458d8f5b8fda81"
#     "owner_id" = "421448405988"
#     "route_table_id" = "rtb-087458d8f5b8fda81"
#     "routes" = tolist([])
#     "subnet_id" = tostring(null)
#     "tags" = tomap({
#       "Name" = "jinsu-private-rt"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-0f8af692fead0eaea"
#   },
#   {
#     "arn" = "arn:aws:ec2:ca-central-1:421448405988:route-table/rtb-079e6beb839030847"
#     "associations" = tolist([
#       {
#         "gateway_id" = ""
#         "main" = false
#         "route_table_association_id" = "rtbassoc-0309d75ee3483e440"
#         "route_table_id" = "rtb-079e6beb839030847"
#         "subnet_id" = "subnet-0a48ca5abc44c202c"
#       },
#       {
#         "gateway_id" = ""
#         "main" = false
#         "route_table_association_id" = "rtbassoc-04f568b6c0d7b396d"
#         "route_table_id" = "rtb-079e6beb839030847"
#         "subnet_id" = "subnet-0c47e5a32380dfac3"
#       },
#     ])
#     "filter" = toset(null) /* of object */
#     "gateway_id" = tostring(null)
#     "id" = "rtb-079e6beb839030847"
#     "owner_id" = "421448405988"
#     "route_table_id" = "rtb-079e6beb839030847"
#     "routes" = tolist([
#       {
#         "carrier_gateway_id" = ""
#         "cidr_block" = "0.0.0.0/0"
#         "core_network_arn" = ""
#         "destination_prefix_list_id" = ""
#         "egress_only_gateway_id" = ""
#         "gateway_id" = "igw-08dd9ebf7680a1486"
#         "instance_id" = ""
#         "ipv6_cidr_block" = ""
#         "local_gateway_id" = ""
#         "nat_gateway_id" = ""
#         "network_interface_id" = ""
#         "transit_gateway_id" = ""
#         "vpc_endpoint_id" = ""
#         "vpc_peering_connection_id" = ""
#       },
#     ])
#     "subnet_id" = tostring(null)
#     "tags" = tomap({
#       "Name" = "terraform-import-test"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-0f8af692fead0eaea"
#   },
#   {
#     "arn" = "arn:aws:ec2:ca-central-1:421448405988:route-table/rtb-03bf56f520ee55227"
#     "associations" = tolist([
#       {
#         "gateway_id" = ""
#         "main" = true
#         "route_table_association_id" = "rtbassoc-0a058f1b63f1b0759"
#         "route_table_id" = "rtb-03bf56f520ee55227"
#         "subnet_id" = ""
#       },
#     ])
#     "filter" = toset(null) /* of object */
#     "gateway_id" = tostring(null)
#     "id" = "rtb-03bf56f520ee55227"
#     "owner_id" = "421448405988"
#     "route_table_id" = "rtb-03bf56f520ee55227"
#     "routes" = tolist([
#       {
#         "carrier_gateway_id" = ""
#         "cidr_block" = "0.0.0.0/0"
#         "core_network_arn" = ""
#         "destination_prefix_list_id" = ""
#         "egress_only_gateway_id" = ""
#         "gateway_id" = "igw-08dd9ebf7680a1486"
#         "instance_id" = ""
#         "ipv6_cidr_block" = ""
#         "local_gateway_id" = ""
#         "nat_gateway_id" = ""
#         "network_interface_id" = ""
#         "transit_gateway_id" = ""
#         "vpc_endpoint_id" = ""
#         "vpc_peering_connection_id" = ""
#       },
#     ])
#     "subnet_id" = tostring(null)
#     "tags" = tomap({})
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-0f8af692fead0eaea"
#   },
# ]
# check_route_tables = [
#   {
#     "filter" = toset(null) /* of object */
#     "id" = "ca-central-1"
#     "ids" = tolist([
#       "rtb-0e4a118bec4626b86",
#       "rtb-087458d8f5b8fda81",
#       "rtb-079e6beb839030847",
#       "rtb-03bf56f520ee55227",
#     ])
#     "tags" = tomap(null) /* of string */
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-0f8af692fead0eaea"
#   },
# ]


# ROUTE_TABLE Import Target
resource "aws_route_table" "rt-tf-import" {
  vpc_id = "vpc-0f8af692fead0eaea"

  tags = {
    "Name" = "rt-tf-import"
  }
}

# ROUTE Import Target 1
resource "aws_route" "r-tf-import-1" {
  route_table_id         = aws_route_table.rt-tf-import.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-08dd9ebf7680a1486"
}

# ROUTE Import Target 2
resource "aws_route" "r-tf-import-2" {
  route_table_id         = aws_route_table.rt-tf-import.id
  destination_cidr_block = "172.32.0.0/24"
  transit_gateway_id     = "tgw-07dc79da1274746a0"
}

# ROUTE_TABLE_ASSOCIATION Import Target 1
resource "aws_route_table_association" "rta-tf-import-1" {
  route_table_id = "rtb-079e6beb839030847"
  subnet_id      = "subnet-0c47e5a32380dfac3"
}

# ROUTE_TABLE_ASSOCIATION Import Target 2
resource "aws_route_table_association" "rta-tf-import-2" {
  route_table_id = aws_route_table.rt-tf-import.id
  subnet_id      = "subnet-0a48ca5abc44c202c"
}
