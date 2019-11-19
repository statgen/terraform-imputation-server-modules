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
# CREATE LOG GROUP FOR VPC FLOW LOGS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  name              = var.vpc_log_group_name
  retention_in_days = var.vpc_log_retention_in_days

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE VPC FLOW LOGS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  vpc_ids = toset(var.vpc_ids)
}

resource "aws_flow_log" "this" {
  for_each = local.vpc_ids

  log_destination = aws_cloudwatch_log_group.this.arn
  iam_role_arn    = var.vpc_flow_logs_iam_role_arn
  vpc_id          = each.value
  traffic_type    = "ALL"
}
