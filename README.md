# terraform_cloud
terraform cloud (https://app.terraform.io/app/insideinfo_jinsu/workspaces)

# 사용 가이드
1. 1_workspace/variables.tf 에 설정된 `TFC_TOKEN`, `TFC_ORGANIZATION_NAME`, `GITHUB_API_TOKEN` 값을 설정
    - `TFC_TOKEN` : 테라폼 클라우드에서 발급받은 토큰
    - `TFC_ORGANIZATION_NAME` : 테라폼 클라우드 ORG 명
    - `GITHUB_API_TOKEN` : GITHUB에서 발급받은 API 토큰
2. 1_workspace 폴더 내에서 `terraform init` `terraform apply` 실행

작성중...