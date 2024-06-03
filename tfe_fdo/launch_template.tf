# FDO 자동 구성을 위한 템플릿 생성

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

## user data template 설정


# data "template_file" "user_data" {
#   template = file("${path.module}/user_data.tpl")

#   vars = {
#     COMPOSE_PROJECT_NAME = "$${COMPOSE_PROJECT_NAME}"
#     HOME                 = "/home/ec2-user"
#     BUCKET               = aws_s3_bucket.fdo.bucket
#     TFE_HOSTNAME         = "${var.prefix}.${var.aws_hostingzone}"
#     TFE_IACT_SUBNETS = join(",", flatten([
#       for az in var.map_subnet_az[var.aws_region] : az.cidr_block
#     ]))
#     TFE_DATABASE_USER            = aws_db_instance.fdo.username
#     TFE_DATABASE_PASSWORD        = aws_db_instance.fdo.password
#     TFE_DATABASE_HOST            = aws_db_instance.fdo.endpoint
#     TFE_DATABASE_NAME            = aws_db_instance.fdo.db_name
#     TFE_OBJECT_STORAGE_S3_REGION = var.aws_region
#     TFE_OBJECT_STORAGE_S3_BUCKET = aws_s3_bucket.fdo.bucket
#     ## todo : redis node hostname 으로 변경 필요
#     # TFE_REDIS_HOST               = "${aws_elasticache_replication_group.name.primary_endpoint_address}:${aws_elasticache_replication_group.name.port}"
#     TFE_REDIS_HOST = "${aws_elasticache_cluster.fdo.cache_nodes[0]["address"]}:${aws_elasticache_cluster.fdo.cache_nodes[0]["port"]}"
#   }
# }

## 시작 템플릿 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "fdo" {
  name                   = "${var.prefix}_template"
  update_default_version = true
  description            = "테라폼으로 자동 생성한 시작 템플릿"

  # 인스턴스 세부 정보
  instance_type = "t3.medium"
  # instance_type = "t3.small"
  image_id      = data.aws_ami.amazon_linux_2.image_id
  # vpc_security_group_ids = [aws_security_group.all.id]
  key_name = var.pem_key_name

  # 스토리지
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#block-devices
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true  # 종료 시 삭제
      volume_type           = "gp3" # 볼륨 유형
      encrypted             = false # 암호화됨
      iops                  = 3000  # IOPS
      throughput            = 125   # 처리량
      volume_size           = 100   # 크기
    }
  }

  # 리소스 태그
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "${var.prefix}_server"
    }
  }

  # 네트워크 인터페이스
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#network-interfaces
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.all.id]
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.fdo.arn
  }

  user_data = base64encode(templatefile(
    "${path.module}/user_data.tpl",
    {
      COMPOSE_PROJECT_NAME = "$${COMPOSE_PROJECT_NAME}"
      HOME                 = "/home/ec2-user"
      BUCKET               = aws_s3_bucket.fdo.bucket
      TFE_HOSTNAME         = aws_route53_record.fdo.name
      TFE_IACT_SUBNETS = join(",", flatten([
        for az in data.aws_subnet.common : az.cidr_block
      ]))
    #   TFE_IACT_SUBNETS = join(",", flatten([
    #     for az in var.map_subnet_az[var.aws_region] : az.cidr_block
    #   ]))
      TFE_DATABASE_USER            = aws_db_instance.fdo.username
      TFE_DATABASE_PASSWORD        = aws_db_instance.fdo.password
      TFE_DATABASE_HOST            = aws_db_instance.fdo.endpoint
      TFE_DATABASE_NAME            = aws_db_instance.fdo.db_name
      TFE_OBJECT_STORAGE_S3_REGION = var.aws_region
      TFE_OBJECT_STORAGE_S3_BUCKET = aws_s3_bucket.fdo.bucket
      ## todo : redis node hostname 으로 변경 필요
      # TFE_REDIS_HOST               = "${aws_elasticache_replication_group.name.primary_endpoint_address}:${aws_elasticache_replication_group.name.port}"
      TFE_REDIS_HOST = "${aws_elasticache_cluster.fdo.cache_nodes[0]["address"]}:${aws_elasticache_cluster.fdo.cache_nodes[0]["port"]}"
    }
  ))
}
