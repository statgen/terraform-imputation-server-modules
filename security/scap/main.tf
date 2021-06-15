# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM STATE BLOCK
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}
}

provider "archive" {}

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Only these AWS Account IDs may be operated on
  allowed_account_ids = var.aws_account_id
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "functions/ProcessSCAPScanResults.py"
  output_path = "functions/function.zip"
}

locals {
  account_id = element(var.aws_account_id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# ENABLE SECURITY HUB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_securityhub_account" "this" {}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE KMS KEY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  description             = "S3 SCAP report encryption key"
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
# CREATE SCAN RESULT BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = var.scap_bucket_name

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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE S3 BUCKET NOTIFICATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".xml"
  }

  depends_on = [aws_lambda_permission.this]
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDA PERMISSION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_permission" "this" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.this.arn
  source_account = local.account_id
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.this.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "this" {
  filename      = "functions/function.zip"
  function_name = "ProcessSCAPScanResults"
  role          = aws_iam_role.process_scap_scan_results.arn
  handler       = "ProcessSCAPScanResults.lambda_handler"

  source_code_hash = data.archive_file.this.output_base64sha256

  runtime = "python3.8"
  memory_size = 1024
  timeout = 360

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SSM PARAMETER STORE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "this" {
  name        = "/SCAPTesting/EnableSecurityHub"
  description = "Determines if Security Hub is used by the ProcessSCAPScanResults Lambda Function"
  type        = "String"
  value       = var.enable_security_hub_findings
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE DYNAMODB TABLES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "ignore_list" {
  name           = "SCAP_Scan_Ignore_List"
  hash_key       = "SCAP_Rule_Name"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "SCAP_Rule_Name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "scan_results" {
  name           = "SCAP_Scan_Results"
  hash_key       = "InstanceId"
  range_key      = "SCAP_Rule_Name"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 2

  attribute {
    name = "InstanceId"
    type = "S"
  }

  attribute {
    name = "SCAP_Rule_Name"
    type = "S"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE INSTANCE PROFILE FOR EC2
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "this" {
  name = "SCAPEC2InstanceProfile"
  role = aws_iam_role.scap_instance_role.name
}

resource "aws_iam_role" "scap_instance_role" {
  name               = "SCAPInstanceRole"
  description        = "Role to be used by instances that are to have the SCAP scans run on them"
  assume_role_policy = data.aws_iam_policy_document.scap_hosts_assume.json

  tags = var.tags
}

resource "aws_iam_policy" "scap_bucket_access" {
  name        = "SCAPBucketAccessPolicy"
  description = "Policy to allow EC2 to push files to the SCAP S3 bucket"
  policy      = data.aws_iam_policy_document.scap_bucket_access.json
}

resource "aws_iam_role_policy_attachment" "scap_bucket_access" {
  role       = aws_iam_role.scap_instance_role.name
  policy_arn = aws_iam_policy.scap_bucket_access.arn
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.scap_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLE FOR LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "process_scap_scan_results" {
  name               = "ProcessSCAPScanResultsRole"
  description        = "Role for the lambda function to allow access to the permissions needed"
  assume_role_policy = data.aws_iam_policy_document.scap_lambda_assume.json

  tags = var.tags
}

resource "aws_iam_policy" "process_scap_scan_results_security_hub" {
  name        = "ProcessSCAPScanResultsSecurityHubPolicy"
  description = "Policy to allow pushing findings to Security Hub"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_security_hub.json
}


resource "aws_iam_role_policy_attachment" "process_scap_scan_results_security_hub" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_security_hub.arn
}

resource "aws_iam_policy" "process_scap_scan_results_log_group" {
  name        = "ProcessSCAPScanResultsLogGroupPolicy"
  description = "Policy to allow the lambda function to push logs to CloudWatch"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_log_group.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_log_group" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_log_group.arn
}

resource "aws_iam_policy" "process_scap_scan_results_s3_access" {
  name        = "ProcessSCAPScanResultsS3AcessPolicy"
  description = "Policy that provides access to the files in the S3 bucket that was created"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_s3_access.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_s3_access" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_s3_access.arn
}

resource "aws_iam_policy" "process_scap_scan_results_cloudwatch" {
  name        = "ProcessSCAPScanResultsCloudWatchPolicy"
  description = "Policy that provides access to push metrics to CloudWatch"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_cloudwatch" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_cloudwatch.arn
}

resource "aws_iam_policy" "process_scap_scan_results_ignore_list" {
  name        = "ProcessSCAPScanResultsIgnoreListPolicy"
  description = "Policy that allows access to read the data from the ignore list DynamoDB table"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_ignore_list.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_ignore_list" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_ignore_list.arn
}

resource "aws_iam_policy" "process_scap_scan_results_scan_results" {
  name        = "ProcessSCAPScanResultsScanResultsPolicy"
  description = "Policy that allows write access to the results table in DynamoDB"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_scan_results.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_scan_results" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_scan_results.arn
}

resource "aws_iam_policy" "process_scap_scan_results_parameter_store" {
  name        = "ProcessSCAPScanResultsParameterStorePolicy"
  description = "Policy for access to the parameter store created for turning on sending findings to security hub"
  policy      = data.aws_iam_policy_document.process_scap_scan_results_parameter_store.json
}

resource "aws_iam_role_policy_attachment" "process_scap_scan_results_parameter_store" {
  role       = aws_iam_role.process_scap_scan_results.name
  policy_arn = aws_iam_policy.process_scap_scan_results_parameter_store.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SSM ASSOCIATION 
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ssm_association" "this" {
  association_name    = "SCAPRunCommandAssociation"
  compliance_severity = "MEDIUM"
  name                = "AWS-RunShellScript"
  schedule_expression = "cron(0 0 12 1/1 * ? *)"

  targets {
    key    = "tag:RunSCAP"
    values = ["True", "true"]
  }

  parameters = {
    commands = "yum install openscap-scanner scap-security-guide -y,if grep -q -i \"release 8\" /etc/redhat-release ; then,scriptFile=\"/usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml\",elif grep -q -i \"release 7\" /etc/redhat-release ; then,scriptFile=\"/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml\",elif grep -q -i \"release 6\" /etc/redhat-release ; then,scriptFile=\"/usr/share/xml/scap/ssg/content/ssg-rhel6-ds.xml\",else,echo \"Running neither RHEL6.x, RHEL7.x or RHEL 8.x !\",fi,if [ \"$scriptFile\" ] ; then,sed -i 's/multi-check=\"true\"/multi-check=\"false\"/g' $scriptFile,oscap xccdf eval --fetch-remote-resources --profile xccdf_org.ssgproject.content_profile_stig --results-arf arf.xml --report report.html $scriptFile,fi,instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id),timestamp=$(date +%s),/usr/local/bin/aws s3 cp arf.xml s3://${aws_s3_bucket.this.id}/$instanceId/$timestamp-scap-results.xml,/usr/local/bin/aws s3 cp report.html s3://${aws_s3_bucket.this.id}/$instanceId/$timestamp-scap-results.html"
  }

}
