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
    default = "bsd-bootstrap.sh"
}

variable "subnet_id" {
    type = string
    default = "subnet-0eb4ae61f04fc16f7"
}

variable "vpc_id" {
    type = string
    default = "vpc-0b0b9d49525f5261b"
}

source "amazon-ebs" "freebsd_base" {
    ami_name = "freebsd-base-{{isotime \"20060102-030405\"}}"
    source_ami = "ami-085ee41974babf1f1"
    ami_description = "Base AMI"
    iam_instance_profile = "BastionHostProfile"

    instance_type = "c5.xlarge"
    # encrypt_boot = true

    vpc_id = var.vpc_id
    subnet_id = var.subnet_id
    region = var.region
    associate_public_ip_address = true

    access_key = var.aws_access_key
    secret_key = var.aws_secret_key

    communicator = "ssh"
    ssh_timeout = "30m"
    ssh_username = "ec2-user"
}

build {
    sources = [
        "source.amazon-ebs.freebsd_base"
    ]

    provisioner "shell" {
        execute_command = "chmod +x {{ .Path }}; su -l root -c sh -c env {{ .Vars }} {{ .Path }}"
        script = var.script_path
    }
}