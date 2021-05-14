variable "aws_access_key" {
  type = string
  default = ""
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  default = ""
  sensitive = true
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "script_path" {
  type = string
  default = "bootstrap.sh"
}

variable "subnet_id" {
  type = string
  default = "subnet-0eb4ae61f04fc16f7"
}

variable "vpc_id" {
  type = string
  default = "vpc-0b0b9d49525f5261b"
}

source "amazon-ebs" "ubuntu_base" {
  ami_name = "ubuntu-20.04-lts-base-{{isotime \"20060102-030405\"}}"
  source_ami = "ami-0be3f0371736d5394"
  ami_description = "Base Ubuntu 20.04 LTS AMI"

  instance_type = "c5.xlarge"
  encrypt_boot = true

  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  region = var.region
  associate_public_ip_address = true

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  communicator = "ssh"
  ssh_username = "ubuntu"
  ssh_clear_authorized_keys = true
}

build {
  sources = [
    "source.amazon-ebs.ubuntu_base"
  ]

  provisioner "file" {
    source = "node_exporter.service"
    destination = "/tmp/node_exporter.service"
  }

  provisioner "file" {
    source = "prometheus.service"
    destination = "/tmp/prometheus.service"
  }

  provisioner "file" {
    source = "prometheus.yml"
    destination = "/tmp/prometheus.yml"
  }

  provisioner "shell" {
    script = var.script_path
  }
}