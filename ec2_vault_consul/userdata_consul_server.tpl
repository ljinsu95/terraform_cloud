#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# sudo yum -y install consul-enterprise-1.15.4+ent-1.$(uname -m)
sudo yum -y install consul-1.15.4-1.$(uname -m)

sudo tee /etc/consul.d/consul.hcl -<<EOF

# datacenter
datacenter = "dc0515"

# data_dir
data_dir = "/opt/consul"

# client_addr
client_addr = "0.0.0.0"

# ui
ui_config{
  enabled = true
}

# server
server = true

# Bind addr
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
#advertise_addr = "127.0.0.1"

# Enterprise License
# license_path = "/etc/consul.d/consul.hclic"

# bootstrap_expect
bootstrap_expect=3

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

sudo tee /etc/consul.d/consul.hclic -<<EOF
${consul_license}
EOF

sudo systemctl enable consul
sudo systemctl start consul