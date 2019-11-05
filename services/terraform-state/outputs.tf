output "this_s3_bucket_arn" {
  description = "The ARN of the S3 bucket for Terraform remote state"
  value       = aws_s3_bucket.this.arn
}

output "this_s3_bucket_id" {
  description = "The ID of the S3 bucket for Terraform remote state"
  value       = aws_s3_bucket.this.id
}

output "this_dynamodb_table_name" {
  description = "The name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.this.name
}

output "this_dynamodb_table_id" {
  description = "The ID of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.this.id
}

output "this_dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.this.arn
}

output "this_kms_key_id" {
  description = "The globally unique identifier for the AWS KMS key used for Terraform state encryption"
  value       = aws_kms_key.this.key_id
}

output "this_kms_key_arn" {
  description = "The ARN for the AWS KMS key used for Terraform state encyrption"
  value       = aws_kms_key.this.arn
}
