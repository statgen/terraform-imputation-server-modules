# ---------------------------------------------------------------------------------------------------------------------
# SCAP HOST POLICY DOCUMENT
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "scap_hosts_assume" {
  statement {
    sid    = "SCAPHosts"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "scap_bucket_access" {
  statement {
    sid    = "SCAPBucketAccessPolicy"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      "${aws_kms_key.this.arn}",
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA FUNCTION POLICY DOCUMENTS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "scap_lambda_assume" {
  statement {
    sid    = "ProcessSCAPScanResults"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_security_hub" {
  statement {
    sid    = "ProcessSCAPScanResultsSecurityHubPolicy"
    effect = "Allow"

    actions = ["securityhub:BatchImportFindings"]

    resources = [
      "arn:aws:securityhub:${var.aws_region}:${aws_securityhub_account.this.id}:*"
    ]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_log_group" {
  statement {
    sid    = "ProcessSCAPResultsLogGroup"
    effect = "Allow"

    actions = ["logs:CreateLogGroup"]

    resources = ["arn:aws:logs:${var.aws_region}:${local.account_id}:*"]
  }

  statement {
    effect = "Allow"

    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = ["arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:/aws/lambda/ProcessSCAPResults:*"]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_s3_access" {
  statement {
    sid    = "ProcessSCAPScanResultsS3AccessPolicy"
    effect = "Allow"

    actions = ["s3:Get*"]

    resources = ["${aws_s3_bucket.this.arn}", "${aws_s3_bucket.this.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    resources = [
      "${aws_kms_key.this.arn}",
    ]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_cloudwatch" {
  statement {
    sid    = "ProcessSCAPResultsCloudWatch"
    effect = "Allow"

    actions = ["cloudwatch:PutMetricData"]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_ignore_list" {
  statement {
    sid    = "ProcessSCAPResultsIgnoredList"
    effect = "Allow"

    actions = ["dynamodb:Scan"]

    resources = [aws_dynamodb_table.ignore_list.arn]
  }
}

data "aws_iam_policy_document" "process_scap_scan_results_scan_results" {
  statement {
    sid    = "ProcessSCAPScanResultsPolicy"
    effect = "Allow"

    actions = ["dynamodb:BatchWriteItem"]

    resources = [aws_dynamodb_table.scan_results.arn]
  }

}

data "aws_iam_policy_document" "process_scap_scan_results_parameter_store" {
  statement {
    sid    = "ProcessSCAPScanResultsParamterStore"
    effect = "Allow"

    actions = ["ssm:GetParameters", "ssm:DescribeParameters", "ssm:GetParameter"]

    resources = [aws_ssm_parameter.this.arn]
  }
}