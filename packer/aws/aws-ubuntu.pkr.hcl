packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws-${formatdate("YY-MM-DD", timestamp())}"
  instance_type = "t2.micro"
  region        = "ca-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    Name    = "jinsu-packer-build-ami"
    builder = "packer"
  }
}

build {
  # name(option) : build name, build 시 <build_name.source_name>으로 실행. build_name이 없을 경우 source_name으로 실행
  # 특정 build만 실행하고 싶을 경우, `packer build -only "build_name.*" ./folder`로 실행 가능
  name = "learn-packer"

  # sources : 사전 정의된 소스에 대한 참조 리스트
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  # provisioner 블록 : 부팅 후 머신 이미지 설치 구성
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing jq",
      "sleep 10",
      "sudo apt-get update",
      "sudo apt-get install -y jq",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }
}
