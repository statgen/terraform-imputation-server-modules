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
# CREATE DOMAIN IDENTITY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}


# ---------------------------------------------------------------------------------------------------------------------
# GET DOMAIN VERIFICATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.id
}


# ---------------------------------------------------------------------------------------------------------------------
# GET DOMAIN DKIM
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}