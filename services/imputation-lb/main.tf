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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

data "aws_acm_certificate" "this" {
  domain = var.domain
}

module "imputation-lb" {
  source = "git@github.com:jdpleiness/terraform-aws-imputation-server.git//modules/imputation-lb"

  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id

  lb_security_group = var.lb_security_group
  lb_subnets        = var.lb_subnets

  master_node_id  = var.master_node_id
  certificate_arn = data.aws_acm_certificate.this.arn

  enable_https = true

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "http_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow ingress HTTP traffic on port 80"

  security_group_id = var.lb_sg_id
}

resource "aws_security_group_rule" "https_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow ingress HTTPS traffic on port 443"

  security_group_id = var.lb_sg_id
}

resource "aws_security_group_rule" "http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.emr_master_sg_id

  description = "Allow egress http traffic on port 80 to EMR master security group"

  security_group_id = var.lb_sg_id
}

resource "aws_security_group_rule" "https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.emr_master_sg_id

  description = "Allow egress https traffic on port 443 to EMR master security group"

  security_group_id = var.lb_sg_id
}

resource "aws_security_group_rule" "imputation_egress" {
  type                     = "egress"
  from_port                = 8082
  to_port                  = 8082
  protocol                 = "tcp"
  source_security_group_id = var.emr_master_sg_id

  description = "Allow egress http traffic on port 8082 to EMR master security group"

  security_group_id = var.lb_sg_id
}

resource "aws_security_group_rule" "all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.lb_sg_id
}
