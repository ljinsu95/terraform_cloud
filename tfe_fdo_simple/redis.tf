# ## redis subnet group 구성
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group
# resource "aws_elasticache_subnet_group" "fdo" {
#   name       = replace("${var.prefix}_redis_subnet_group", "_", "-") # 언더바 사용 불가
#   subnet_ids = data.aws_subnets.common.ids
#   # subnet_ids = aws_subnet.fdo.*.id
#   tags = {
#     Name = "${var.prefix}_redis_subnet_group"
#   }
# }


# ## redis parameter group 구성
# resource "aws_elasticache_parameter_group" "fdo_redis_cluster" {
#   name   = replace("${var.prefix}_redis_cluster_parameter_group", "_", "-") # 언더바 사용 불가
#   family = "redis7"
# }


# ## redis cluster 구성
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster
# resource "aws_elasticache_cluster" "fdo" {
#   cluster_id                 = lower(replace("${var.prefix}_redis", "_", "-")) # redis cluster 명 (소문자 및 하이픈 만 지원)
#   engine                     = "redis"
#   node_type                  = "cache.t4g.micro"
#   num_cache_nodes            = 1                                                      # redis node 갯수
#   parameter_group_name       = aws_elasticache_parameter_group.fdo_redis_cluster.name # 파라미터 구성 명
#   engine_version             = "7.1"                                                  # redis 버전
#   auto_minor_version_upgrade = false
#   port                       = 6379
#   security_group_ids         = [aws_security_group.all.id]           # 보안 그룹 id 리스트
#   subnet_group_name          = aws_elasticache_subnet_group.fdo.name # redis subnet group 명
# }

# ## redis 복제
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group
# # resource "aws_elasticache_replication_group" "name" {
# #   automatic_failover_enabled = true
# #   engine                     = "redis"
# #   engine_version             = "7.1"
# #   auto_minor_version_upgrade = false
# #   # preferred_cache_cluster_azs = [var.map_subnet_az[var.aws_region][0].availability_zone]
# #   preferred_cache_cluster_azs = flatten([for az in var.map_subnet_az[var.aws_region] : az.availability_zone])
# #   replication_group_id        = lower(replace("${var.prefix}_redis_rep_group", "_", "-"))
# #   description                 = "example description"
# #   node_type                   = "cache.t4g.micro"
# #   multi_az_enabled            = false
# #   num_cache_clusters          = 2
# #   parameter_group_name        = aws_elasticache_parameter_group.fdo.name
# #   subnet_group_name           = aws_elasticache_subnet_group.fdo.name
# #   port                        = 6379
# # }
