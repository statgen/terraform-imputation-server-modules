data "aws_iam_policy_document" "aws_config_assume" {
  statement {
    sid    = "ConfigAssume"
    effect = "Allow"

    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "aws_config_bucket_access" {
  statement {
    sid    = "AWSConfigBucketWriteAccessPolicy"
    effect = "Allow"

    actions = [
      "s3:PutObject*",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket_name}",
      "arn:aws:s3:::${var.config_bucket_name}/*"
    ]
  }

  statement {
    sid    = "AWSConfigBucketReadAccessPolicy"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.config_bucket_name}"
    ]
  }
}

data "aws_iam_policy_document" "aws_config_kms_access" {
  statement {
    sid    = "AWSConfigKMSAccessPolicy"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = [
      var.config_bucket_kms_arn
    ]
  }
}