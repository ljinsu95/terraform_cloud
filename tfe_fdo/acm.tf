# TLS 구성을 위한 ACM 생성

## TLS private_key.pem 생성
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key.html
resource "tls_private_key" "fdo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

## TLS cert.pem 생성
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert
resource "tls_self_signed_cert" "fdo" {
  private_key_pem = tls_private_key.fdo.private_key_pem
  dns_names       = [aws_route53_record.fdo.name]

  # 인증서 요청 대상 지정
  subject {
    country             = "KR"
    province            = "Seoul"
    locality            = "Gang-Nam"
    organization        = "Insideinfo, Inc"
    organizational_unit = "Engineering"
    common_name         = aws_route53_record.fdo.name # DNS 명
  }

  validity_period_hours = 24 * 30 # 발급 후 인증서가 유효한 상태로 유지되는 시간

  # 발급된 인증서에 허용된 키 사용 목록
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  depends_on = [aws_route53_record.fdo]
}

## AWS ACM 인증서 가져오기로 등록
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "aws_acm_certificate" "cert" {
  private_key       = tls_private_key.fdo.private_key_pem # private_key.pem
  certificate_body  = tls_self_signed_cert.fdo.cert_pem   # cert.pem
  certificate_chain = tls_self_signed_cert.fdo.cert_pem   # 인증서 체인은 cert.pem과 동일한 키 사용
}

########################
### ACM Resource END ###
########################
