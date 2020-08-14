provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 3.2"

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
  required_version = ">= 0.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDTRAIL
# ---------------------------------------------------------------------------------------------------------------------

module "cloudtrail" {
  source = "github.com/nozaq/terraform-aws-secure-baseline.git//modules/cloudtrail-baseline?ref=0.16.2"

  aws_account_id = element(var.aws_account_id, 0)

  cloudtrail_name                   = var.cloudtrail_name
  cloudwatch_logs_group_name        = var.cloudwatch_logs_group_name
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  enabled = var.enabled

  region = var.aws_region

  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix

  tags = var.tags
}
