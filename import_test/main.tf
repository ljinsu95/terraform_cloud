## 사용가능한 vpc 목록 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs
data "aws_vpcs" "existing" {}


## 사용가능한 VPC 조회
### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "selected" {
  id = data.aws_vpcs.existing.ids[0]
}

data "aws_subnet" "common" {
  filter {
    name   = "subnet-id"
    values = ["subnet-025c2a3452d71747d"]
  }
}

# import {
#   id = data.aws_subnet.common.id
#   to = aws_subnet.test
# }

resource "aws_subnet" "test" {
  vpc_id = data.aws_vpc.selected.id
  cidr_block = data.aws_subnet.common.cidr_block
}

output "import_output" {
  value = aws_subnet.test.arn
}
