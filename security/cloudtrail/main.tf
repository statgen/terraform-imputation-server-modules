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
