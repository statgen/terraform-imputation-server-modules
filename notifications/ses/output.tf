output "aws_ses_domain_identity_arn" {
  description = "The ARN of the domain identity"
  value       = aws_ses_domain_identity.this.arn
}

output "aws_ses_domain_identity_verification_token" {
  description = "The code which when added to the domain as a TXT record will signal SES that the domain is verified"
  value       = aws_ses_domain_identity.this.verification_token
}

output "aws_ses_domain_dkim_tokens" {
  description = "DKIM tokens generated by SES"
  value       = aws_ses_domain_dkim.this.dkim_tokens
}