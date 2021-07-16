# ---------------------------------------------------------------------------------------------------------------------
# CREATE AWS CONFIG AGGREGATE AUTH
# ---------------------------------------------------------------------------------------------------------------------

/*
data "aws_regions" "current" {}

resource "aws_config_aggregate_authorization" "this" {
  for_each = data.aws_regions.current.names

  account_id = var.aws_account_id
  region     = each.key
}
*/

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AWS CONFIG RECORDER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_config_configuration_recorder_status" "this" {
  is_enabled = var.is_enabled
  name       = aws_config_configuration_recorder.this.name

  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_configuration_recorder" "this" {
  role_arn = aws_iam_role.aws_config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  s3_bucket_name = aws_s3_bucket.this.bucket

  depends_on = [aws_config_configuration_recorder.this]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM ROLES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "aws_config" {
  name               = "AWSConfigTrustPolicy"
  description        = "Role for AWS Config to access the permissions needed"
  assume_role_policy = data.aws_iam_policy_document.aws_config_assume.json

  tags = var.tags
}

// AWS managed policy for AWS Config resource access
resource "aws_iam_role_policy_attachment" "aws_config" {
  role       = aws_iam_role.aws_config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

// Access to S3 bucket for Config results
resource "aws_iam_role_policy_attachment" "aws_config_bucket_access" {
  role       = aws_iam_role.aws_config.name
  policy_arn = aws_iam_policy.aws_config_bucket_access.arn
}

resource "aws_iam_policy" "aws_config_bucket_access" {
  name        = "AWSConfigBucketAccessPolicy"
  description = "Policy to allow AWS Config access to S3 bucket"
  policy      = data.aws_iam_policy_document.aws_config_bucket_access.json
}

// Access to KMS for S3 bucket encryption
resource "aws_iam_role_policy_attachment" "aws_config_kms_access" {
  role       = aws_iam_role.aws_config.name
  policy_arn = aws_iam_policy.aws_config_kms_access.arn
}

resource "aws_iam_policy" "aws_config_kms_access" {
  name        = "AWSConfigKMSAccessPolicy"
  description = "Policy to allow AWS Config access to KMS for S3 object encryption/decryption"
  policy      = data.aws_iam_policy_document.aws_config_kms_access.json
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE KMS KEY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  description             = "AWS Config bucket encryption key"
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
# CREATE AWS CONFIG BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = var.config_bucket_name

  acl = "private"

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

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}