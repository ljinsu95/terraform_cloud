#!/bin/bash
# 1. Docker 설치 및 실행
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

cd ${HOME}
# 2. Docker Compose Plugin 설치
## DOcker Compose Plugin 다운로드
curl https://download.docker.com/linux/centos/8/x86_64/stable/Packages/docker-compose-plugin-2.10.2-3.el8.x86_64.rpm -o docker-compose-plugin.rpm

## Docker Compose Plugin 설치
sudo yum install -y docker-compose-plugin.rpm

# 3. S3 Bucket을 통해 TLS 인증서 및 TFE-FDO 라이센스 다운로드
## TLS 인증서 다운로드
aws s3 cp s3://${BUCKET}/terraform/certs/key.pem ${HOME}/certs/key.pem
aws s3 cp s3://${BUCKET}/terraform/certs/cert.pem ${HOME}/certs/cert.pem
aws s3 cp s3://${BUCKET}/terraform/certs/bundle.pem ${HOME}/certs/bundle.pem

## TFE-FDO 라이센스 다운로드
aws s3 cp s3://${BUCKET}/terraform/tfe_license/terraform.hclic /tmp/terraform/terraform.hclic

## (Option) TLS 인증서 이동 (실제 사용되는 파일은 /home/ec2-user/certs/*)
sudo mkdir -p /etc/ssl/private/terraform-enterprise
sudo cp ${HOME}/certs/*.pem /etc/ssl/private/terraform-enterprise

# 4. TFE-FDO Docker 이미지 파일 Pull
## TFE-FDO 라이센스를 통해 Docker(images.releases.hashicorp.com) 로그인
cat /tmp/terraform/terraform.hclic | sudo docker login --username terraform images.releases.hashicorp.com --password-stdin

## Docker Pull (terraform version : v202311-1)
sudo docker pull images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1


# 5. Docker Compose 파일 설정
tee compose.yaml -<<EOF
---
name: terraform-enterprise
services:
  tfe:
    ## 이미지 버전 설정 v202311-1
    image: images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1
    environment:
      ## 라이센스 추가
      # TFE_LICENSE: "$(cat /tmp/terraform/terraform.hclic)"
      TFE_LICENSE_PATH: "/tmp/terraform/terraform.hclic"
      ## hostname 추가
      TFE_HOSTNAME: "${TFE_HOSTNAME}"
      ## 암호화 패스워드 지정
      TFE_ENCRYPTION_PASSWORD: "insideinfo_good"
      TFE_OPERATIONAL_MODE: "active-active"
      TFE_DISK_CACHE_VOLUME_NAME: "${COMPOSE_PROJECT_NAME}_terraform-enterprise-cache"
      TFE_TLS_CERT_FILE: "/etc/ssl/private/terraform-enterprise/cert.pem"
      TFE_TLS_KEY_FILE: "/etc/ssl/private/terraform-enterprise/key.pem"
      TFE_TLS_CA_BUNDLE_FILE: "/etc/ssl/private/terraform-enterprise/bundle.pem"
      ## 서브넷 cidr 지정
      TFE_IACT_SUBNETS: "${TFE_IACT_SUBNETS}"

      # Database settings. See the configuration reference for more settings.
      ## postgre 사용자 명
      TFE_DATABASE_USER: "${TFE_DATABASE_USER}"
      ## postgre 패스워드
      TFE_DATABASE_PASSWORD: "${TFE_DATABASE_PASSWORD}"
      ## postgre 호스트 명
      TFE_DATABASE_HOST: "${TFE_DATABASE_HOST}"
      ## postgre database 명
      TFE_DATABASE_NAME: "${TFE_DATABASE_NAME}"
      ## postgre 접속 파라미터
      ## TFE_DATABASE_PARAMETERS: "sslmode=disable"

      # Object storage settings. See the configuration reference for more settings.
      TFE_OBJECT_STORAGE_TYPE: "s3"
      ## aws key
      #TFE_OBJECT_STORAGE_S3_ACCESS_KEY_ID: ""
      #TFE_OBJECT_STORAGE_S3_SECRET_ACCESS_KEY: ""
      # AWS INSTANCE PROFILE 사용 여부
      TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE: "true"
      ## S3 리전
      TFE_OBJECT_STORAGE_S3_REGION: "${TFE_OBJECT_STORAGE_S3_REGION}"
      ## S3 명
      TFE_OBJECT_STORAGE_S3_BUCKET: "${TFE_OBJECT_STORAGE_S3_BUCKET}"

      # Redis settings. See the configuration reference for more settings.
      TFE_REDIS_HOST: "${TFE_REDIS_HOST}"
#      TFE_REDIS_USER: "<Redis username>"
#      TFE_REDIS_PASSWORD: "<Redis password>"
#       TFE_REDIS_USE_TLS: "false"
#       TFE_REDIS_USE_AUTH: "false"

      # Vault cluster settings.
      # If you are using the default internal vault, this should be the private routable IP address of the node itself.
      ## 프라이빗 주소 입력
      TFE_VAULT_CLUSTER_ADDRESS: "http://$(ec2-metadata -o | cut -d " " -f 2):8201"
    cap_add:
      - IPC_LOCK
    read_only: true
    tmpfs:
      - /tmp:mode=01777
      - /run
      - /var/log/terraform-enterprise
    ports:
      - "80:80"
      - "443:443"
      - "8201:8201"
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /run/docker.sock
      - type: bind
        source: ./certs
        target: /etc/ssl/private/terraform-enterprise
      - type: volume
        source: terraform-enterprise-cache
        target: /var/cache/tfe-task-worker/terraform
      - type: bind
        source: /tmp/terraform
        target: /tmp/terraform
volumes:
  terraform-enterprise-cache:
EOF

# 6. 컨테이너 백그라운드 실행
sudo docker compose up --detach

# 7. (Option) 컨테이너 로그 조회
# sudo docker compose logs --follow

# 8. (Option) 컨테이너 상태 체크
# sudo docker compose exec tfe tfe-health-check-status