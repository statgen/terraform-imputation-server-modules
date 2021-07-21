output "aws_config_role_arn" {
  description = "The ARN of the AWS Config role"
  value       = aws_iam_role.aws_config.arn
}

output "aws_config_role_name" {
  description = "The name of the IAM role used by AWS Config"
  value       = aws_iam_role.aws_config.name
}