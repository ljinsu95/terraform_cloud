locals {
  # db_info 오브젝트 중 used=true 인 값만 리스트로 추출
  enabled_database = { for k, v in var.db_info : k => v if v.used }
}
