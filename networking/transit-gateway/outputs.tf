output "transit_gateway_arn" {
  description = "Transit Gateway Amazon Resource Name"
  value       = module.transit_gateway.this_ec2_transit_gateway_arn
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.transit_gateway.this_ec2_transit_gateway_id
}
