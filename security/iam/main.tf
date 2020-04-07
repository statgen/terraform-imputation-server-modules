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
  required_version = "= 0.12.24"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE FULL-ACCESS GROUP AND ATTACH POLICY
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_iam_group" "full_access" {
#   name = "full-access"
# }

# resource "aws_iam_group_policy_attachment" "force_mfa" {
#   group      = aws_iam_group.full_access.name
#   policy_arn = aws_iam_policy.force_mfa.arn
# }

# resource "aws_iam_group_policy_attachment" "full_access" {
#   group      = aws_iam_group.full_access.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROLE AND INSTANCE PROFILE FOR BASTION HOST
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "bastion_host" {
  name               = "BastionHostRole"
  description        = "Delegate permissions for Bastion Host"
  assume_role_policy = data.aws_iam_policy_document.allow_ec2_access.json
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
