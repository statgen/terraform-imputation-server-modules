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
