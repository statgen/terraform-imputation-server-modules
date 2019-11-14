output "route53_record_name" {
  description = "The name of the Route53 record"
  value       = aws_route53_record.a.name
}

output "route53_record_fqdn" {
  description = "The FQDN of the record"
  value       = aws_route53_record.a.fqdn
}

output "security_headers_lambda_arn" {
  description = "The ARN of the Lambda Function to set security headers"
  value       = aws_lambda_function.this.arn
}

output "security_headers_lambda_qualified_arn" {
  description = "The qualified ARN of the Lambda Function to set security headers"
  value       = aws_lambda_function.this.qualified_arn
}

output "cloudfront_distribution_id" {
  description = "The identifier for the distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_arn" {
  description = "The ARN for the distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name for the distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The hosted zone ID for the distribution"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
