# terraform_cloud
terraform cloud (https://app.terraform.io/app/insideinfo_jinsu/workspaces)

# 사용 가이드
## 1. 1_workspace : Terraform Cloud 구성
Terraform Cloud에 Workspace 생성 및 VCS(GitHub) 연동

1. 1_workspace/variables.tf 에 설정된 `TFC_TOKEN`, `TFC_ORGANIZATION_NAME`, `GITHUB_API_TOKEN` 값을 설정
    - `TFC_TOKEN` : 테라폼 클라우드에서 발급받은 토큰
    - `TFC_ORGANIZATION_NAME` : 테라폼 클라우드 ORG 명
    - `GITHUB_API_TOKEN` : GITHUB에서 발급받은 API 토큰
2. 1_workspace 폴더 내에서 `terraform init`, `terraform apply` 실행

## tfe_fdo
terraform enterprise fdo(active/active) 구성
### 변수
- `AWS_ACCESS_KEY_ID` : AWS ACCESS KEY
- `AWS_SECRET_ACCESS_KEY` : AWS SECRET KEY
- `TFE_FDO_LICENSE` : TFE FDO 라이센스
- `aws_region` : AWS 사용 리전 (기본값 : `ca-central-1`)
- `aws_hostingzone` : AWS Route 53에 등록된 호스팅 영역 명
- `pem_key_name` : AWS PEM KEY 명
### 생성 리소스 목록
- ACM
- Route53 Record
- ALB
- 시작 템플릿
- S3 : `TFE_FDO_LICENSE` 및 `TLS_KEY` 저장 용도
- RDS : PostgreSQL
- Redis
- 보안 그룹 : 전체 허용
## vault_db_engine
Vault 엔터프라이즈 환경에서 Database Engine 테스트를 하기 위한 AWS RDS 및 Vault Database Role 생성
### 변수
- `AWS_ACCESS_KEY_ID` : AWS ACCESS KEY
- `AWS_SECRET_ACCESS_KEY` : AWS SECRET KEY
- `aws_region` : AWS 사용 리전 (기본값 : `ca-central-1`)





작성중...
