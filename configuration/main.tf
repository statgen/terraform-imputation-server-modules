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
  required_version = "= 0.12.28"
}

# ---------------------------------------------------------------------------------------------------------------------
# UPLOAD FILES FOR IMPUTATION SERVER BOOTSTRAP
# ---------------------------------------------------------------------------------------------------------------------

locals {
  data_path           = "bucket-data"
  bootstrap_path      = "${local.data_path}/bootstrap.sh"
  apps_file_path      = "${local.data_path}/apps.yaml"
  settings_file_path  = "${local.data_path}/settings.yaml"
  cloudgene_conf_path = "${local.data_path}/cloudgene.conf"
  clougene_aws_path   = "${local.data_path}/cloudgene-aws"
}

resource "aws_s3_bucket_object" "bootstrap_script" {
  bucket = var.bucket_name
  key    = "bootstrap.sh"
  source = local.bootstrap_path

  etag = filemd5(local.bootstrap_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "apps_file" {
  bucket = var.bucket_name
  key    = "apps.yaml"
  source = local.apps_file_path

  etag = filemd5(local.apps_file_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "settings_file" {
  bucket = var.bucket_name
  key    = "configuration/config/settings.yaml"
  source = local.settings_file_path

  etag = filemd5(local.settings_file_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "cloudgene_conf" {
  bucket = var.bucket_name
  key    = "configuration/cloudgene.conf"
  source = local.cloudgene_conf_path

  etag = filemd5(local.cloudgene_conf_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "cloudgene_aws" {
  bucket = var.bucket_name
  key    = "configuration/cloudgene-aws"
  source = local.clougene_aws_path

  etag = filemd5(local.clougene_aws_path)

  tags = var.tags
}