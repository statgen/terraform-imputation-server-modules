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

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "script_path" {
  type    = string
  default = "bootstrap.sh"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0eb4ae61f04fc16f7"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b0b9d49525f5261b"
}

data "amazon-ami" "amazon_linux_2" {
  filters = {
    virtualization-type = "hvm"
    name = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
    root-device-type = "ebs"
  }
  owners = ["amazon"]
  most_recent = true
}

source "amazon-ebs" "monitoring" {
  ami_name        = "monitoring-${formatdate("YYYYMMDD-hms", timestamp())}"
  source_ami      = data.amazon-ami.amazon_linux_2.id
  ami_description = "Monitoring host image"

  instance_type = "c5.xlarge"
  # encrypt_boot  = true

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  region                      = var.region
  associate_public_ip_address = true


  ssh_username              = "ec2-user"
  ssh_clear_authorized_keys = true
}

build {
  sources = [
    "source.amazon-ebs.monitoring"
  ]

  // provisioner "file" {
  //   source      = "node_exporter.service"
  //   destination = "/tmp/node_exporter.service"
  // }

  // provisioner "file" {
  //   source      = "prometheus.service"
  //   destination = "/tmp/prometheus.service"
  // }

  // provisioner "file" {
  //   source      = "prometheus.yml"
  //   destination = "/tmp/prometheus.yml"
  // }

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    galaxy_file   = "requirements.yml"
  }

  // provisioner "shell" {
  //   script = var.script_path
  // }
}