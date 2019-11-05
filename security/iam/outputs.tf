output "full_access_group_id" {
  description = "The ID of the full-access group"
  value       = aws_iam_group.full_access.id
}

output "full_access_group_arn" {
  description = "The ARN of the full-access group"
  value       = aws_iam_group.full_access.arn
}

output "full_access_group_unique_id" {
  description = "The unique ID assigned to the full-access group by AWS"
  value       = aws_iam_group.full_access.unique_id
}

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
