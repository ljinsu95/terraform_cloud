#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install vault-enterprise-1.14.8+ent-1.$(uname -m)
# sudo yum -y install consul-enterprise-1.15.4+ent-1.$(uname -m)
sudo yum -y install consul-1.15.4-1.$(uname -m)

sudo tee /etc/vault.d/vault.hcl -<<EOF
# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
disable_mlock = true
cluster_addr  = "http://{{ GetInterfaceIP \"eth0\" }}:8201"
api_addr      = "http://{{ GetInterfaceIP \"eth0\" }}:8200"

#storage "file" {
#  path = "/opt/vault/data"
#}

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

# HTTP listener
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

# HTTPS listener
#listener "tcp" {
#  address       = "0.0.0.0:8200"
#  tls_cert_file = "/opt/vault/tls/tls.crt"
#  tls_key_file  = "/opt/vault/tls/tls.key"
#}

# Enterprise license_path
license_path = "/etc/vault.d/vault.hclic"

#disable_performance_standby = false

# Example AWS KMS auto unseal
# seal "awskms" {
#   region = "ca-central-1"
#   kms_key_id = ""
# }

# reporting disable
reporting {
  license {
    enabled = false
  }
}
EOF

sudo tee /etc/consul.d/consul.hcl -<<EOF
# Fullconfiguration options can be found at https://www.consul.io/docs/agent/options.html

# datacenter
datacenter = "dc0515"

# data_dir
data_dir = "/opt/consul"

# client_addr
#client_addr = "0.0.0.0"

# ui
#ui_config{
#  enabled = true
#}

# server
#server = true

# Bind addr
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"

# Advertise addr - if you want to point clients to a different address than bind or LB.
#advertise_addr = "127.0.0.1"

# Enterprise License
# license_path = "/etc/consul.d/consul.hclic"

# bootstrap_expect
#bootstrap_expect=3

# encrypt
encrypt = "tI//eQ8S2JWtTMvSROlPwsM4FriiaJlyi87KKGkUYGw="

# retry_join
retry_join = ["provider=aws tag_key=${tag_key} tag_value=${tag_value}"]

performance {
  raft_multiplier = 1
}

# reporting disable
reporting {
  license {
    enabled = false
  }
}

EOF

sudo tee /etc/vault.d/vault.hclic -<<EOF
${vault_license}
EOF

sudo tee /etc/consul.d/consul.hclic -<<EOF
${consul_license}
EOF

sudo systemctl enable consul
sudo systemctl enable vault

sudo systemctl start consul
sudo systemctl start vault