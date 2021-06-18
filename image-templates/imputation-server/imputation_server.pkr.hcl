
variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "script_path" {
  type    = string
  default = "bootstrap.sh"
}

variable "subnet_id" {
  type    = string
  default = "subnet-093605eb850e61c57"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b0b9d49525f5261b"
}

source "amazon-ebs" "autogenerated_1" {
  access_key                  = "${var.aws_access_key}"
  ami_description             = "Base AMI for imputation server EMR instances"
  ami_name                    = "imputation-server-${formatdate("YYYYMMDD-hms", timestamp())}"
  associate_public_ip_address = true
  instance_type               = "t2.large"
  region                      = "${var.aws_region}"
  secret_key                  = "${var.aws_secret_key}"
  source_ami                  = "ami-0db83b0151355345a"
  ssh_username                = "ec2-user"
  subnet_id                   = "${var.subnet_id}"
  tags = {
    Name = "imputation-server-base"
  }
  vpc_id = "${var.vpc_id}"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "file" {
    destination = "/tmp/node_exporter.service"
    source      = "node_exporter.service"
  }

  provisioner "file" {
    destination = "/tmp/cloudwatch-config.json"
    source      = "cloudwatch-config.json"
  }

  provisioner "shell" {
    script = "${var.script_path}"
  }

}
