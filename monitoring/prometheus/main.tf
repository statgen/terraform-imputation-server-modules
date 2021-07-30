# ----------------------------------------------------------------------------------------------------------------------
# CREATE EC2 INSTANCE(S)
# ----------------------------------------------------------------------------------------------------------------------

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["monitoring-server-*"]
  }

  owners = [local.account_id]
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count = 1

  name          = "${var.name_prefix}-mon"
  ami           = data.aws_ami.this.id
  instance_type = var.instance_type

  associate_public_ip_address = false

  vpc_security_group_ids = [var.monitoring_sg_id]

  subnet_ids = [element(var.private_subnets, 0)]

  iam_instance_profile = var.monitoring_host_instance_profile_name

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.root_volume_size
    },
  ]

  tags = var.tags
}
