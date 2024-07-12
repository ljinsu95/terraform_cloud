# 라우팅 테이블 정보 조회
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table
data "aws_route_table" "garget" {
  route_table_id = "rtb-0f503b63c3c523cd3"
  # route_table_id = "rtb-0e4a118bec4626b86"
}

# 라우팅 테이블 임포팅
import {
  id = data.aws_route_table.garget.id
  to = aws_route_table.main
}

# 라우팅 테이블 리소스
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "main" {
  vpc_id = data.aws_route_table.garget.vpc_id
  # route = toset(data.aws_route_table.garget.routes)
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = "igw-08dd9ebf7680a1486"
  # }
  tags = data.aws_route_table.garget.tags
}

locals {
  # 방법 1.
  list_of_objects = data.aws_route_table.garget.associations

  map_of_objects_1 = {
    for obj in local.list_of_objects : obj.route_table_association_id => {
      route_table_id = obj.route_table_id
      subnet_id      = obj.subnet_id
    }
  }
  # 방법 2.
  indices = range(length(data.aws_route_table.garget.associations))
  map_of_objects_2 = zipmap(
    local.indices,
    data.aws_route_table.garget.associations
  )
}

# 라우팅 테이블 - 서브넷 연결 임포팅
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#import
import {
  for_each = local.map_of_objects_2
  to       = aws_route_table_association.main[each.key]
  id       = "${each.value.subnet_id}/${each.value.route_table_id}"
}

# # 라우팅 테이블 - 서브넷 연결 리소스
resource "aws_route_table_association" "main" {
  for_each = local.map_of_objects_2

  route_table_id = each.value.route_table_id
  subnet_id      = each.value.subnet_id
}

output "import_output" {
  value = data.aws_route_table.garget
}
output "data_routes" {
  value = data.aws_route_table.garget.routes
}
output "resource_route" {
  value = aws_route_table.main.route
}
output "map_of_objects_1" {
  value = local.map_of_objects_1
}
output "map_of_objects_2" {
  value = local.map_of_objects_2
}
