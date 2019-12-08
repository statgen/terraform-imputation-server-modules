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
  required_version = "= 0.12.17"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE KMS KEY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  description             = "S3 log bucket encryption key"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
  is_enabled              = var.kms_is_enabled

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.this.key_id
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LOG BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "logs" {
  bucket = var.logs_bucket_name

  acl = "private"

  logging {
    target_bucket = aws_s3_bucket.access_logs.id
  }

  versioning {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.key_id
      }
    }
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ACCESS LOG BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "access_logs" {
  bucket = var.access_logs_bucket_name

  acl = "log-delivery-write"

  versioning {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE TLD REDIRECT BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "tld_redirect" {
  bucket = var.tld_redirect_bucket_name

  acl = "public-read"

  website {
    redirect_all_requests_to = "https://${var.tld_redirect_destination}"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION SERVER BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "imputation_server" {
  bucket = var.imputation_server_bucket_name

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.key_id
      }
    }
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH POLICY TO BUCKETS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.this.json
}
