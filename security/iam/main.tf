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
# CREATE FULL-ACCESS GROUP AND ATTACH POLICY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_group" "full_access" {
  name = "full-access"
}

resource "aws_iam_group_policy_attachment" "force_mfa" {
  group      = aws_iam_group.full_access.name
  policy_arn = aws_iam_policy.force_mfa.arn
}

resource "aws_iam_group_policy_attachment" "full_access" {
  group      = aws_iam_group.full_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM POLICY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "force_mfa" {
  name        = "ForceMFA"
  description = "Force MFA usage for all resources except to set MFA itself"
  policy      = data.aws_iam_policy_document.force_mfa.json
}
