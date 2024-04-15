variable "prefix" {
  default     = "terraform_jinsu"
  description = "prefix"
}

variable "TFC_TOKEN" {
  type        = string
  description = "테라폼 토큰"
  sensitive   = true
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS ACCESS KEY"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS SECRET ACCESS KEY"
  sensitive   = true
}

variable "aws_region" {
  default     = "ca-central-1"
  # default     = "ap-northeast-2"
  description = "aws region"
}

variable "aws_vpc_cidr" {
  default     = "172.170.0.0/16"
  description = "AWS VPC CIDR"
}

### az, cidr 설정
variable "map_subnet_az" {
  type = map(
    list(
      object(
        {
          availability_zone = string
          # cidr_block        = string
        }
      )
    )
  )

  default = {
    ## ca-central-1
    "ca-central-1" = [
      {
        availability_zone = "ca-central-1a"
        # cidr_block        = cidrsubnets(var.aws_vpc_cidr, 8, 8, 8, 8)[0]
      },
      {
        availability_zone = "ca-central-1b"
        # cidr_block        = cidrsubnets(var.aws_vpc_cidr, 8, 8, 8, 8)[1]
      },
    ],

    ## ap-northeast-2
    "ap-northeast-2" = [
      {
        availability_zone = "ap-northeast-2a"
        # cidr_block        = cidrsubnets(var.aws_vpc_cidr, 8, 8, 8, 8)[0]
      },
      {
        availability_zone = "ap-northeast-2c"
        # cidr_block        = cidrsubnets(var.aws_vpc_cidr, 8, 8, 8, 8)[1]
      },
      {
        availability_zone = "ap-northeast-2d"
        # cidr_block        = cidrsubnets(var.aws_vpc_cidr, 8, 8, 8, 8)[2]
      },
    ]
  }

  description = "Subnet AZ 설정 값 목록"
}

variable "pem_key_name" {
  default     = "jinsu"
  description = "AWS PEM KEY 명"
}
