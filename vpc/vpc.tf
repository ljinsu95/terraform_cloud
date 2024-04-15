##########################
### VPC Resource START ###
##########################
## VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr

  instance_tenancy     = "default"
  enable_dns_hostnames = true # DNS 호스트 네임 활성화 여부 RDS publicly_accessible 활성화시 필요

  tags = {
    Name = "${var.prefix}_vpc"
  }
}

## Subnet
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "main" {
  # count = length(var.map_subnet_az[var.aws_region]) # 지정한 AZ 수 만큼 Subnet 생성
  count = length(lookup(var.map_subnet_az, var.aws_region)) # 지정한 AZ 수 만큼 Subnet 생성

  vpc_id = aws_vpc.main.id

  availability_zone = var.map_subnet_az[var.aws_region][count.index].availability_zone
  # cidr_block        = var.map_subnet_az[var.aws_region][count.index].cidr_block
  cidr_block        = cidrsubnet(var.aws_vpc_cidr, 8, count.index)

  map_public_ip_on_launch = true # 퍼블릭 IP 주소 자동 할당

  tags = {
    Name = "${var.prefix}_subnet_public${tonumber(count.index) + 1}-${var.map_subnet_az[var.aws_region][count.index].availability_zone}"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}_igw"
  }

}

## Route Table
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.prefix}_rtb_public"
  }
}

## Route Table 연결
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "rtb_sn" {
  count          = length(var.map_subnet_az[var.aws_region])
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main.id
}

## Security Group
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "all" {
  name   = "${var.prefix}-All-allowed"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}_sg_All_allowed"
  }
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
## Network ACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  
  # Vault reporting ip deny start
  egress {
    protocol   = "tcp"
    rule_no    = 80
    action     = "deny"
    cidr_block = "100.20.70.12/32"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 81
    action     = "deny"
    cidr_block = "35.166.5.222/32"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 82
    action     = "deny"
    cidr_block = "23.95.85.111/32"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 83
    action     = "deny"
    cidr_block = "44.215.244.1/32"
    from_port  = 443
    to_port    = 443
  }
  # Vault reporting ip deny end

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.prefix}-acl"
  }
}

## Network ACL 연결
resource "aws_network_acl_association" "main" {
  count          = length(var.map_subnet_az[var.aws_region])
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.main[count.index].id
}
########################
### VPC Resource END ###
########################