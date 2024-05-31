# ALB 구성

## 대상 그룹 생성 (HTTPS)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "fdo_https" {
  target_type = "instance"
  name        = replace("${var.prefix}-lb-tg-443", "_", "-")
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.selected.id
  # vpc_id      = aws_vpc.fdo.id


  # heath check 설정
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
  health_check {
    enabled  = true
    protocol = "HTTPS"
    path     = "/_health_check"
    matcher  = "200-399"
  }
}

## 대상 그룹 생성 (HTTP)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "fdo_http" {
  target_type = "instance"
  name        = replace("${var.prefix}-lb-tg-8800", "_", "-")
  port        = 8800
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  # vpc_id      = aws_vpc.fdo.id

  # heath check 설정
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
  }
}

## ALB 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "fdo" {
  name               = replace("${var.prefix}-alb", "_", "-")
  internal           = false # 내부망 여부
  load_balancer_type = "application"
  security_groups    = [aws_security_group.all.id]
  subnets            = data.aws_subnets.common.ids
  # subnets            = aws_subnet.fdo.*.id

  enable_deletion_protection = false # 삭제 보호 활성화 (true인 경우 Terraform이 로드밸런스 삭제 불가)
}

## ALB Listener(HTTPS) 추가
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "fdo_https" {
  load_balancer_arn = aws_lb.fdo.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # SSL 정책 명 https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies
  certificate_arn   = aws_acm_certificate.cert.arn          # SSL 서버 인증서의 ARN

  default_action {
    type             = "forward"                         # forward : 대상 그룹으로 전달
    target_group_arn = aws_lb_target_group.fdo_https.arn # 트래픽을 라우팅할 대상 그룹의 ARN
  }
}

## ALB Listener(HTTP) 추가
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "fdo_http" {
  load_balancer_arn = aws_lb.fdo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect" # redirect : URL로 리디렉트

    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#redirect
    redirect {
      protocol    = "HTTPS"
      port        = 443
      status_code = "HTTP_301" # 영구 이동
    }
  }
}
