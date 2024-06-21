#!/bin/bash
# docker install
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

cd ${HOME}
curl https://download.docker.com/linux/centos/8/x86_64/stable/Packages/docker-compose-plugin-2.10.2-3.el8.x86_64.rpm -o docker-compose-plugin.rpm

sudo yum install -y docker-compose-plugin.rpm

## pem download
aws s3 cp s3://${BUCKET}/terraform/certs/key.pem ${HOME}/certs/key.pem
aws s3 cp s3://${BUCKET}/terraform/certs/cert.pem ${HOME}/certs/cert.pem
aws s3 cp s3://${BUCKET}/terraform/certs/bundle.pem ${HOME}/certs/bundle.pem
aws s3 cp s3://${BUCKET}/terraform/tfe_license/terraform.hclic /tmp/terraform/terraform.hclic

sudo mkdir -p /etc/ssl/private/terraform-enterprise
sudo cp ${HOME}/certs/*.pem /etc/ssl/private/terraform-enterprise

# docker 로그인
cat /tmp/terraform/terraform.hclic | sudo docker login --username terraform images.releases.hashicorp.com --password-stdin

# docker pull
# terraform version : v202311-1
sudo docker pull images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1



tee compose.yaml -<<EOF
---
version: "3.9"
name: terraform-enterprise
services:
  tfe:
    # image: quay.io/hashicorp/terraform-enterprise:v202311-1
    image: images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1
    depends_on:
      - minio
      - postgres
    environment:
      TFE_HOSTNAME: "${TFE_HOSTNAME}"
      TFE_OPERATIONAL_MODE: "active-active"    
      TFE_ENCRYPTION_PASSWORD: "hashicorp"
      TFE_DISK_CACHE_VOLUME_NAME: ${COMPOSE_PROJECT_NAME}_terraform-enterprise-cache
      TFE_TLS_CERT_FILE: /etc/ssl/private/terraform-enterprise/cert.pem
      TFE_TLS_KEY_FILE: /etc/ssl/private/terraform-enterprise/key.pem
      TFE_TLS_CA_BUNDLE_FILE: /etc/ssl/private/terraform-enterprise/bundle.pem
      # Redis settings.
      TFE_REDIS_HOST: redis:6379
      TFE_REDIS_USER: redisadmin
      TFE_REDIS_PASSWORD: redisadmin
      TFE_REDIS_USE_TLS: false
      TFE_REDIS_USE_AUTH: false
      # Database settings.
      TFE_DATABASE_USER: "hashicorp"
      TFE_DATABASE_PASSWORD: "hashicorp"
      TFE_DATABASE_HOST: "postgres:5432"
      TFE_DATABASE_NAME: "hashicorp"
      TFE_DATABASE_PARAMETERS: "sslmode=disable"
      # Object storage settings.
      TFE_OBJECT_STORAGE_TYPE: "s3"
      TFE_OBJECT_STORAGE_S3_ACCESS_KEY_ID: "terraformaccess"
      TFE_OBJECT_STORAGE_S3_SECRET_ACCESS_KEY: "terraformsecret"
      TFE_OBJECT_STORAGE_S3_REGION: "${TFE_OBJECT_STORAGE_S3_REGION}"
      TFE_OBJECT_STORAGE_S3_ENDPOINT: "http://minio:9000"
      TFE_OBJECT_STORAGE_S3_BUCKET: "tfe"
      TFE_OBJECT_STORAGE_S3_SERVER_SIDE_ENCRYPTION: ""
      # TFE_OBJECT_STORAGE_S3_SERVER_SIDE_ENCRYPTION: "<empty or aws:kms>"
      TFE_LICENSE_PATH: "/terraform/terraform.hclic"
    cap_add:
      - IPC_LOCK
    read_only: true
    tmpfs:
      - /tmp
      - /run
      - /var/log/terraform-enterprise
    ports:
      - "80:80"
      - "443:443"
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
        source: /terraform
        target: /terraform

  redis:
    image: redis:alpine
    command: redis-server --port 6379
    container_name: redis_boot
    hostname: redis_boot
    labels:
      - "name=redis"
      - "mode=standalone"
    ports:
      - 6379:6379


  postgres:
    image: postgres:14
    environment:
      POSTGRES_USER: hashicorp
      POSTGRES_PASSWORD: hashicorp
      POSTGRES_DB: hashicorp
    volumes:
      - type: volume
        source: postgres
        target: /var/lib/postgresql/data
  minio:
    image: minio/minio:latest
    command: ["server", "/data", "--console-address", ":9001"]
    environment:
      MINIO_ROOT_USER: terraformaccess
      MINIO_ROOT_PASSWORD: terraformsecret
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - type: volume
        source: minio
        target: /data
  minio-bucket:
    image: minio/mc
    depends_on:
      - minio
    entrypoint: >
      /bin/sh -c "
      /usr/bin/mc alias set myminio http://minio:9000 terraformaccess terraformsecret;
      /usr/bin/mc mb myminio/tfe;
      exit 0;
      "

volumes:
  minio:
  postgres:
  terraform-enterprise-cache:
EOF

# 컨테이너 백그라운드 실행
sudo docker compose up --detach

# 컨테이너 로그 조회
# sudo docker compose logs --follow

# 컨테이너 상태 체크
# sudo docker compose exec tfe tfe-health-check-status