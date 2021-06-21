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

data "amazon-ami" "amazon_linux_2" {
  filters = {
    virtualization-type = "hvm"
    name                = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}

source "amazon-ebs" "amzn2" {
  ami_name        = "amzn2-ami-hvm-base-x86_64-gp2-${formatdate("MMM-DD-YYYY-hh.mm.ss", timestamp())}"
  source_ami      = data.amazon-ami.amazon_linux_2.id
  ami_description = "AMZN Linux 2 hardened base"

  instance_type = "c5.large"
  encrypt_boot  = true

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.aws_region
  associate_public_ip_address = true

  ssh_username              = "ec2-user"
  ssh_clear_authorized_keys = true

  tags = {
    Name = "AMZN Linux 2 hardened base image"
  }
}

build {
  sources = [
    "source.amazon-ebs.amzn2"
  ]

  provisioner "file" {
    destination = "/tmp/banner.txt"
    source      = "banner.txt"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/banner.txt /etc/issue"]
  }

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    galaxy_file   = "requirements.yml"
  }
}