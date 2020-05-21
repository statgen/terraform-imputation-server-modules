output "transit_gateway_arn" {
  description = "Transit Gateway Amazon Resource Name"
  value       = module.transit-gateway.this_ec2_transit_gateway_arn
}

ouput "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = modlue.tansit-gateway.this_ec2_transit_gateway_id
}
