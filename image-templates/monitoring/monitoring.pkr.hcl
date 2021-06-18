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

variable "ami_owner" {
  type      = string
  default   = "879094716711"
  sensitive = true
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0eb4ae61f04fc16f7"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b0b9d49525f5261b"
}

data "amazon-ami" "base_image" {
  filters = {
    virtualization-type = "hvm"
    name                = "amzn2-ami-hvm-base-x86_64-gp2"
    root-device-type    = "ebs"
  }
  owners      = [var.ami_owner]
  most_recent = true
}

source "amazon-ebs" "monitoring" {
  ami_name        = "monitoring-ami-hvm-x86_64-gp2"
  source_ami      = data.amazon-ami.base_image.id
  ami_description = "Monitoring host image"

  instance_type = "c5.xlarge"

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.region
  associate_public_ip_address = true


  ssh_username              = "ec2-user"
  ssh_clear_authorized_keys = true

  tags = {
    Name = "Monitoring image for imputation environment"
  }
}

build {
  sources = [
    "source.amazon-ebs.monitoring"
  ]

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    galaxy_file   = "requirements.yml"
  }
}