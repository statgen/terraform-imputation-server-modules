output "lb_id" {
  description = "The ID of the load balancer (same as ARN)"
  value       = module.imputation-lb.lb_id
}

output "lb_arn" {
  description = "The ARN of the load balancer (same as ID)"
  value       = module.imputation-lb.lb_arn
}

output "lb_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics"
  value       = module.imputation-lb.lb_arn_suffix
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.imputation-lb.lb_dns_name
}

output "lb_name" {
  description = "The name of the load balancer"
  value       = module.imputation-lb.lb_name
}

output "lb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = module.imputation-lb.lb_zone_id
}
