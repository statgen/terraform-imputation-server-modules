# ---------------------------------------------------------------------------------------------------------------------
# CREATE LOG GROUP FOR VPC FLOW LOGS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  name              = var.vpc_log_group_name
  retention_in_days = var.vpc_log_retention_in_days

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE VPC FLOW LOGS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  vpc_ids = toset(var.vpc_ids)
}

resource "aws_flow_log" "this" {
  for_each = local.vpc_ids

  log_destination = aws_cloudwatch_log_group.this.arn
  iam_role_arn    = var.vpc_flow_logs_iam_role_arn
  vpc_id          = each.value
  traffic_type    = "ALL"
}
