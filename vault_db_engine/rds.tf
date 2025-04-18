# RDS (PostgreSQL) 생성

## RDS DB Subnet Group 구성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "vault" {
  name       = "${var.prefix}_db_subnet_group_vault" # aws_db_instance.db_subnet_group_name에서 사용
  subnet_ids = data.aws_subnets.common.ids

  tags = {
    Name = "${var.prefix}_db_subnet_group_vault"
  }
}

## RDS 구성 (RDS Aurora 사용 시 aws_rds_cluster 리소스 구성)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "vault" {
  for_each = local.enabled_database

  identifier = replace("${var.prefix}_${each.key}_vault", "_", "-") # RDS 데이터베이스 식별자 명 (언더바 사용 불가)

  engine                      = each.value.engine         # 지원 하는 값은 https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html#API_CreateDBInstance_RequestParameters - Engine 확인
  engine_version              = each.value.engine_version # 지원하는 버전 목록 https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false

  db_name  = each.value.db_name
  username = each.value.username
  password = each.value.password

  instance_class         = "db.t3.micro" # RDS 인스턴스의 인스턴스 유형
  storage_type           = "gp3"
  allocated_storage      = 20
  availability_zone      = data.aws_availability_zones.available.names[0]
  multi_az               = false # 다중 AZ 여부
  db_subnet_group_name   = aws_db_subnet_group.vault.name
  publicly_accessible    = true # public access 가능 여부
  skip_final_snapshot    = true # DB 인스턴스가 삭제되기 전 최종 DB 스냅샷 생성 스킵 여부
  vpc_security_group_ids = [aws_security_group.all.id]
}
