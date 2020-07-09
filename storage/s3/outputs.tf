output "imputation_server_bucket_id" {
  description = "The name of the S3 bucket used for Imputation Server"
  value = aws_s3_bucket.imputation_server.id
}

output "this_kms_key_id" {
  description = "The globally unique identifier for the AWS KMS key used for log buckets"
  value       = aws_kms_key.this.key_id
}

output "this_kms_key_arn" {
  description = "The ARN for the AWS KMS key used for log buckets"
  value       = aws_kms_key.this.arn
}

output "log_bucket_id" {
  description = "The name of the S3 bucket used for logs"
  value       = aws_s3_bucket.logs.id
}

output "log_bucket_arn" {
  description = "The ARN of the S3 bucket used for logs"
  value       = aws_s3_bucket.logs.arn
}

output "log_bucket_domain_name" {
  description = "The domain name of the S3 bucket used for logs"
  value       = aws_s3_bucket.logs.bucket_domain_name
}

output "access_log_bucket_id" {
  description = "The name of the S3 bucket used for access logs"
  value       = aws_s3_bucket.access_logs.id
}

output "access_log_bucket_arn" {
  description = "The ARN of the S3 bucket used for access logs"
  value       = aws_s3_bucket.access_logs.arn
}

