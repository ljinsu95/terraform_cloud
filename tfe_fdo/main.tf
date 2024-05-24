###########################
### Route 53 구성 START ###
###########################

## Route 53 호스팅 영역 조회
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "selected" {
  name = var.aws_hostingzone # 호스팅 영역 이름으로 데이터 조회
}

## Route 53 레코드 추가
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "fdo" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.prefix}.${var.aws_hostingzone}" # 레코드 이름
  type    = "A"
  alias {
    name                   = aws_lb.fdo.dns_name # LB DNS 명
    zone_id                = aws_lb.fdo.zone_id  # LB 호스팅 영역 ID
    evaluate_target_health = false               # 대상 상태 평가
  }
}

#########################
### Route 53 구성 END ###
#########################

############################
### S3 Bucket 구성 Start ###
############################
# S3 Bucket에 TLS PEM KEY와 TFE License를 저장해두고, 시작 템플릿 User Data에서 사용
## S3 Bucket 추가
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "fdo" {
  bucket = lower(replace("${var.prefix}_bucket", "_", "-"))
}

## S3 Bucket 파일(terraform.hclic) 업로드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "license" {
  bucket  = aws_s3_bucket.fdo.bucket
  key     = "terraform/tfe_license/terraform.hclic"
  content = var.TFE_FDO_LICENSE
}

## S3 Bucket 파일(cert.pem) 업로드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "cert_pem" {
  bucket  = aws_s3_bucket.fdo.bucket
  key     = "terraform/certs/cert.pem"
  content = tls_self_signed_cert.fdo.cert_pem
}

## S3 Bucket 파일(key.pem) 업로드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "private_key_pem" {
  bucket  = aws_s3_bucket.fdo.bucket
  key     = "terraform/certs/key.pem"
  content = tls_private_key.fdo.private_key_pem
}

## S3 Bucket 파일(bundle.pem) 업로드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "bundle_pem" {
  bucket  = aws_s3_bucket.fdo.bucket
  key     = "terraform/certs/bundle.pem"
  content = tls_self_signed_cert.fdo.cert_pem
}

##########################
### S3 Bucket 구성 END ###
##########################




### todo... ASG 생성
## Auto Scale Group 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "fdo" {
  name = "${var.prefix}_asg"

  # 1. 시작 템플릿 또는 구성 선택
  # launch_configuration = aws_launch_template.fdo.name
  launch_template {
    name    = aws_launch_template.fdo.name
    version = "$Default" # 사용할 템플릿 버전 $Default, $Latest 사용 가능
  }

  # 2. 인스턴스 시작 옵션 선택
  vpc_zone_identifier = data.aws_subnets.common.ids
  # vpc_zone_identifier = aws_subnet.fdo.*.id

  # 3. 고급 옵션 구성
  target_group_arns = [aws_lb_target_group.fdo_http.arn, aws_lb_target_group.fdo_https.arn] # ALB 대상 그룹 선택

  # 4. 그룹 크기 및 크기 조정 구성
  max_size = 1
  min_size = 1
}
