# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM USERS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_user" "this" {
  for_each = var.user_names

  name          = each.key
  path          = each.value["path"]
  force_destroy = each.value["force_destroy"]

  tags = merge(tomap({ "EmailAddress" = each.value["tag_email"], "Terraform" = true }), var.tags)
}

resource "aws_iam_user_group_membership" "this" {
  for_each = var.group_memberships

  user   = each.key
  groups = each.value

  depends_on = [aws_iam_user.this]
}

# ---------------------------------------------------------------------------------------------------------------------
# SET AWS ACCOUNT ALIAS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_account_alias" "alias" {
  account_alias = var.aws_account_alias
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE GROUP AND ROLE FOR ADMIN PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------

## Create "UMAdminRole"
resource "aws_iam_role" "um_admin" {
  name               = "UMAdminRole"
  description        = "Allow Admin access for UM Admins"
  assume_role_policy = data.aws_iam_policy_document.um_admin_role_assume.json

  tags = var.tags
}

## Attach AdministratorAccess policy to UMAdmin role
resource "aws_iam_role_policy_attachment" "um_admin" {
  role       = aws_iam_role.um_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLE AND INSTANCE PROFILE FOR BASTION HOST
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "bastion_host" {
  name               = "BastionHostRole"
  description        = "Delegate permissions for Bastion Host"
  assume_role_policy = data.aws_iam_policy_document.allow_ec2_access.json

  tags = var.tags
}

resource "aws_iam_instance_profile" "bastion_host" {
  name = "BastionHostProfile"
  role = aws_iam_role.bastion_host.name
}

## Attach Policy for Bastion Host
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_instance_connect" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLE FOR LAMBDA EDGE FUNCTION AND ATTACH POLICY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "lambda_edge" {
  name               = "LambdaEdgeRole"
  description        = "Delegate permissions for Lambda@Edge functions"
  assume_role_policy = data.aws_iam_policy_document.allow_lambda_access.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basics" {
  role       = aws_iam_role.lambda_edge.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLE FOR FLOWLOGS TO CLOUDWATCH
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "flowlogs_cloudwatch" {
  name               = "FlowLogsCloudwatchDeliveryRole"
  description        = "Delegate permissions for Flowlogs to push logs to CloudWatch"
  assume_role_policy = data.aws_iam_policy_document.flowlogs_trust.json

  tags = var.tags
}

resource "aws_iam_policy" "flowlogs_cloudwatch" {
  name        = "FlowLogsCloudWatchWrite"
  description = "Allow FlowLogs to write to CloudWatch log stream"
  policy      = data.aws_iam_policy_document.flowlogs_to_cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "flowlogs_cloudwatch" {
  role       = aws_iam_role.flowlogs_cloudwatch.name
  policy_arn = aws_iam_policy.flowlogs_cloudwatch.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLES FOR MONITORING INSTANCE(S)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "monitoring_hosts" {
  name               = "MonitoringHosts"
  assume_role_policy = data.aws_iam_policy_document.allow_ec2_access.json

  tags = var.tags
}

resource "aws_iam_instance_profile" "monitoring_hosts" {
  name = aws_iam_role.monitoring_hosts.name
  role = aws_iam_role.monitoring_hosts.name
}

resource "aws_iam_role_policy_attachment" "monitoring_ssm" {
  role       = aws_iam_role.monitoring_hosts.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "monitoring_read_only_ec2" {
  role       = aws_iam_role.monitoring_hosts.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLES FOR EMR CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "emr" {
  name               = "EMRClusterRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_emr.json

  tags = var.tags
}

resource "aws_iam_role" "ec2" {
  name               = "EMREC2InstanceRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  tags = var.tags
}

resource "aws_iam_role" "ec2_autoscaling" {
  name               = "EMREC2AutoscalingRole"
  assume_role_policy = data.aws_iam_policy_document.application_autoscaling.json

  tags = var.tags
}

resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
}

# Attach Policy Documents to EMR Roles
resource "aws_iam_role_policy_attachment" "emr" {
  role       = aws_iam_role.emr.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_autoscaling" {
  role       = aws_iam_role.ec2_autoscaling.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM POLICY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "force_mfa" {
  name        = "ForceMFA"
  description = "Force MFA usage for all resources except to set MFA itself"
  policy      = data.aws_iam_policy_document.force_mfa.json
}
