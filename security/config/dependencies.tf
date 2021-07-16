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
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }

  statement {
    sid    = "AWSConfigBucketReadAccessPolicy"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      aws_s3_bucket.this.arn
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
      aws_kms_key.this.arn
    ]
  }
}