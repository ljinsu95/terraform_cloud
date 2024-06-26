# packer install
### MacOS
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer

packer --version
```

# packer aws plugin install
```bash
packer plugins install github.com/hashicorp/amazon
packer init .
```

# packer build
```bash
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_KEY>
packer build ./aws-ubuntu.pkr.pkr.hcl
```
