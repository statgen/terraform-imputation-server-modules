output "scap_server_bucket_id" {
  description = "The name of the S3 bucket for SCAP results"
  value       = aws_s3_bucket.this.id
}

output "kms_key_id" {
  description = "The globally unique identifier for the AWS KMS key use for the SCAP S3 bucket"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "The ARN for the AWS key used for SCAP bucket"
  value       = aws_kms_key.this.arn
}