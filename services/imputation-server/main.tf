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
# CREATE IMPUTATION SERVER EMR CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

locals {
  ec2_subnet = element(var.ec2_subnet, 0)
}

module "imputation-server" {
  source = "git@github.com:jdpleiness/terraform-aws-imputation-server.git//modules/imputation-server"

  name_prefix = var.name_prefix

  vpc_id                            = var.vpc_id
  ec2_subnet                        = local.ec2_subnet
  emr_managed_master_security_group = var.emr_managed_master_security_group
  emr_managed_slave_security_group  = var.emr_managed_slave_security_group
  service_access_security_group     = var.service_access_security_group

  public_key = var.public_key

  bootstrap_action = var.bootstrap_action

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.bastion_host_sg_id

  description = "Allow ingress SSH from bastion host"

  security_group_id = var.emr_master_sg_id
}

resource "aws_security_group_rule" "http_ingress" {
  type                     = "ingress"
  from_port                = 8082
  to_port                  = 8082
  protocol                 = "tcp"
  source_security_group_id = var.lb_sg_id

  description = "Allow ingress HTTP traffic on port 8082 from ELB"

  security_group_id = var.emr_master_sg_id
}

resource "aws_security_group_rule" "emr_master_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.emr_master_sg_id
}

resource "aws_security_group_rule" "emr_slave_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all egress traffic"

  security_group_id = var.emr_slave_sg_id
}
