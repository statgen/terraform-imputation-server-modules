output "aggregator_arn" {
  description = "The ARN of the AWS Config aggregator"
  value       = aws_config_configuration_aggregator.this.arn
}

output "aggregator_name" {
  description = "The name of the AWS Config aggregator"
  value       = aws_config_configuration_aggregator.this.name
}