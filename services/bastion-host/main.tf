provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 2.6"

  # Only these AWS Account IDs may be operated on
  allowed_account_ids = var.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM STATE BLOCK
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}

  # Only allow this Terraform version. Note that if you upgrade to a newer version, Terraform won't allow you to use an
  # older version, so when you upgrade, you should upgrade everyone on your team and your CI servers all at once.
  required_version = "= 0.12.13"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE EC2 BASTION HOST INSTANCE(S)
# ----------------------------------------------------------------------------------------------------------------------

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["csg/images/csg-bastion-*"]
  }

  owners = ["536148068215"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.8.0"

  instance_count = 1

  name          = "${var.name_prefix}-bastion-host"
  ami           = data.aws_ami.this.id
  instance_type = var.instance_type

  associate_public_ip_address = true

  vpc_security_group_ids = [var.bastion_host_sg_id]

  subnet_ids = [element(var.public_subnets, 0)]

  iam_instance_profile = var.bastion_host_instance_profile_name

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.root_volume_size
    },
  ]

  user_data = "${file("user-data/startup.sh")}"

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 RECORD
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "a" {
  zone_id = var.mgmt_route53_zone_id
  name    = "bastion.mgmt.imputationserver.org"
  type    = "A"
  ttl     = "300"

  records = [element(module.ec2_instance.public_ip, 0)]
}
