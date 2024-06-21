# S3 권한 획득을 위한 IAM 생성

## IAM Policy 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "s3" {
  name        = "${var.prefix}_S3_policy"
  description = "${var.prefix}_S3_policy"
  path        = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetBucketLocation"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.fdo.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.fdo.bucket}"
        ]
      },
      {
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"

      },
    ]
  })
}

## IAM Role 신뢰 관계 정책 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

## IAM Role 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "fdo" {
  name                = "${var.prefix}_role"
  assume_role_policy  = data.aws_iam_policy_document.ec2_trust_policy.json
  managed_policy_arns = [aws_iam_policy.s3.arn]
}

## IAM instance profile 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "fdo" {
  name = "${var.prefix}_profile"
  role = aws_iam_role.fdo.name
}