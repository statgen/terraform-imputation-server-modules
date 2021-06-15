packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_access_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_id" {
  type    = string
  default = "subnet-093605eb850e61c57"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b0b9d49525f5261b"
}

source "amazon-ebs" "amzn" {
  ami_name        = "amzn-base-{{isotime \"20060102-030405\"}}"
  source_ami      = "ami-0ff8a91507f77f867"
  ami_description = "AMZN Linux hardened base"

  instance_type = "c5.large"
  encrypt_boot  = true

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.aws_region
  associate_public_ip_address = true

  ssh_username = "ec2-user"
}

source "amazon-ebs" "amzn2" {
  ami_name        = "amzn2-base-{{isotime \"20060102-030405\"}}"
  source_ami      = "ami-0aeeebd8d2ab47354"
  ami_description = "AMZN Linux 2 hardened base"

  instance_type = "c5.large"
  encrypt_boot  = true

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.aws_region
  associate_public_ip_address = true

  ssh_username = "ec2-user"
}

source "amazon-ebs" "ubuntu" {
  ami_name        = "ubuntu-20.04-LTS-base-{{isotime \"20060102-030405\"}}"
  source_ami      = "ami-01de8ddb33de7a3d3"
  ami_description = "Ubuntu 20.04 LTS hardened base"

  instance_type = "c5.large"
  encrypt_boot  = true

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.aws_region
  associate_public_ip_address = true

  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.amzn2"
  ]

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    galaxy_file   = "galaxy.yml"
  }
}