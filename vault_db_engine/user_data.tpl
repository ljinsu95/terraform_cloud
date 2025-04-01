#!/bin/bash
export ENABLE_POSTGRESQL=${ENABLE_POSTGRESQL}
export ENABLE_MYSQL=${ENABLE_MYSQL}

export PGUSER=${PGUSER}
export PGPASSWORD=${PGPASSWORD}
export PGHOSTNAME=${PGHOSTNAME}
export PGDBNAME=${PGDBNAME}

export MYSQL_USER=${MYSQL_USER}
export MYSQL_PWD=${MYSQL_PWD}
export MYSQL_HOSTNAME=${MYSQL_HOSTNAME}
export MYSQL_DBNAME=${MYSQL_DBNAME}

if [ "$ENABLE_POSTGRESQL" = "true" ]; then
    # RHEL 7용 EPEL 릴리스 패키지를 설치하고 EPEL 리포지토리를 활성화합니다.
    sudo amazon-linux-extras install -y epel

    # pgdg13 다운로드 설정
    sudo tee /etc/yum.repos.d/pgdg.repo -<<EOF
[pgdg13]
name=PostgreSQL 13 for RHEL/CentOS 7 - x86_64
baseurl=http://download.postgresql.org/pub/repos/yum/13/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
EOF

    # postgresql 설치
    sudo yum install -y postgresql13

    # postgresql sql문 생성
    tee /tmp/postgresql.sql -<<EOF
create user vault_admin with login password 'insideinfo';
create user db_user with login password 'insideinfo';
alter user vault_admin WITH CREATEROLE;
EOF

    # postgresql sql문 실행
    PGPASSWORD=$PGPASSWORD psql -h $PGHOSTNAME -U $PGUSER -d $PGDBNAME -f /tmp/postgresql.sql
fi

if [ "$ENABLE_MYSQL" = "true" ]; then
    # mysql 설치
    sudo yum install -y mysql

    # mysql sql문 생성
    tee /tmp/mysql.sql -<<EOF
CREATE user 'vault_admin'@'%' identified BY 'insideinfo';
GRANT CREATE USER, SELECT on *.* to 'vault_admin'@'%' with grant option;
CREATE USER 'db_user'@'%' IDENTIFIED BY 'insideinfo';
GRANT SELECT ON *.* TO 'db_user'@'%' WITH GRANT OPTION;
EOF


    # mysql sql문 실행
    mysql -h $MYSQL_HOSTNAME -u $MYSQL_USER -p$MYSQL_PWD -e "source /tmp/mysql.sql"

fi

# 모든 조건이 거짓일 때 실행될 명령어
# echo "Neither PostgreSQL nor MySQL is enabled."
