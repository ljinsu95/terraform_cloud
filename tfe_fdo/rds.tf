# RDS (PostgreSQL) 생성

## RDS DB Subnet Group 구성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "fdo" {
  name       = "${var.prefix}_db_subnet_group" # aws_db_instance.db_subnet_group_name에서 사용
  subnet_ids = data.aws_subnets.common.ids
#   subnet_ids = aws_subnet.fdo.*.id

  tags = {
    Name = "${var.prefix}_db_subnet_group"
  }
}

## RDS 구성 (RDS Aurora 사용 시 aws_rds_cluster 리소스 구성)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "fdo" {
  identifier = replace("${var.prefix}_postgre", "_", "-") # RDS 데이터베이스 식별자 명 (언더바 사용 불가)

  engine                      = "postgres" # 지원 하는 값은 https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html#API_CreateDBInstance_RequestParameters - Engine 확인
  engine_version              = "15"       # 지원하는 버전 목록 https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false

  db_name  = "${var.prefix}_database"
  username = "postgres"
  password = "insideinfo"

  instance_class         = "db.t3.micro" # RDS 인스턴스의 인스턴스 유형
  allocated_storage      = 10
  availability_zone      = data.aws_availability_zones.available.names[0]
#   availability_zone      = var.map_subnet_az[var.aws_region][0].availability_zone
  multi_az               = false # 다중 AZ 여부
  db_subnet_group_name   = aws_db_subnet_group.fdo.name
  publicly_accessible    = true # public access 가능 여부
  skip_final_snapshot    = true # DB 인스턴스가 삭제되기 전 최종 DB 스냅샷 생성 스킵 여부
  vpc_security_group_ids = [aws_security_group.all.id]
}