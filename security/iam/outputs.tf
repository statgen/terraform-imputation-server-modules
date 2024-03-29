output "bastion_host_role_arn" {
  description = "The ARN of the bastion host role"
  value       = aws_iam_role.bastion_host.arn
}

output "bastion_host_role_id" {
  description = "The ID of the bastion host role"
  value       = aws_iam_role.bastion_host.id
}

output "bastion_host_role_name" {
  description = "The name of the bastion host role"
  value       = aws_iam_role.bastion_host.name
}

output "bastion_host_instance_profile_arn" {
  description = "The ARN of the bastion host instance profile"
  value       = aws_iam_instance_profile.bastion_host.arn
}

output "bastion_host_instance_profile_name" {
  description = "The name of hte bastion host instance profile"
  value       = aws_iam_instance_profile.bastion_host.name
}

output "bastion_host_instance_profile_role" {
  description = "The role assigned to the bastion host instance profile"
  value       = aws_iam_instance_profile.bastion_host.role
}

output "monitoring_role_arn" {
  description = "The ARN of the monitoring role"
  value       = aws_iam_role.monitoring_hosts.arn
}

output "monitoring_role_id" {
  description = "The ID of the monitoring role"
  value       = aws_iam_role.monitoring_hosts.id
}

output "monitoring_role_name" {
  description = "The name of the monitoring role"
  value       = aws_iam_role.monitoring_hosts.name
}

output "monitoring_instance_profile_arn" {
  description = "The ARN of the monitoring instance profile"
  value       = aws_iam_instance_profile.monitoring_hosts.arn
}

output "monitoring_instance_profile_name" {
  description = "The name of the monitoring instance profile"
  value       = aws_iam_instance_profile.monitoring_hosts.name
}

output "monitoring_instance_profile_role" {
  description = "The role assigned to the monitoring instance profile"
  value       = aws_iam_instance_profile.monitoring_hosts.role
}

output "lambda_edge_role_id" {
  description = "The ID of the Lambda Edge role"
  value       = aws_iam_role.lambda_edge.id
}

output "lambda_edge_role_arn" {
  description = "The ARN of the Lambda Edge role"
  value       = aws_iam_role.lambda_edge.arn
}

output "lambda_edge_role_name" {
  description = "The name of the Lambda Edge role"
  value       = aws_iam_role.lambda_edge.name
}

output "flowlogs_role_id" {
  description = "The ID of the FlowLogs role"
  value       = aws_iam_role.flowlogs_cloudwatch.id
}

output "flowlogs_role_arn" {
  description = "The ARN of the FlowLogs role"
  value       = aws_iam_role.flowlogs_cloudwatch.arn
}

output "flowlogs_role_name" {
  description = "The name of the FlowLogs role"
  value       = aws_iam_role.flowlogs_cloudwatch.name
}

output "emr_role_arn" {
  description = "The ARN of the EMR role"
  value       = aws_iam_role.emr.arn
}

output "emr_role_name" {
  description = "The name of the EMR role"
  value       = aws_iam_role.emr.name
}

output "emr_role_unique_id" {
  description = "The stable and unique string identifying the EMR role"
  value       = aws_iam_role.emr.unique_id
}

output "ec2_role_arn" {
  description = "The ARN of the EC2 role"
  value       = aws_iam_role.ec2.arn
}

output "ec2_role_name" {
  description = "The name of the EC2 role"
  value       = aws_iam_role.ec2.name
}

output "ec2_role_unique_id" {
  description = "The stable and unique string identifying the EC2 role"
  value       = aws_iam_role.emr.unique_id
}

output "ec2_autoscaling_role_arn" {
  description = "The ARN of the EC2 autoscaling role"
  value       = aws_iam_role.ec2_autoscaling.arn
}

output "ec2_autoscaling_role_name" {
  description = "The name of the EC2 autoscaling role"
  value       = aws_iam_role.ec2_autoscaling.name
}

output "ec2_autoscaling_role_unique_id" {
  description = "The stable and unique string identifying the EC2 autoscaling role"
  value       = aws_iam_role.ec2_autoscaling.unique_id
}

output "ec2_instance_profile_id" {
  description = "The ID of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.id
}

output "ec2_instance_profile_arn" {
  description = "The ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.arn
}

output "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.name
}

output "user_ids" {
  value = {
    for user_name in aws_iam_user.this :
    user_name.name => user_name.unique_id
  }
}

output "user_arns" {
  value = {
    for user_name in aws_iam_user.this :
    user_name.name => user_name.arn
  }
}