output "availability_zone" {
  description = "The availability zone of the monitoring host"
  value       = element(module.ec2_instance.availability_zone, 0)
}

output "id" {
  description = "The instance ID of the monitoring host"
  value       = element(module.ec2_instance.id, 0)
}

output "primary_network_interface_id" {
  description = "The ID of the primary network interface"
  value       = element(module.ec2_instance.primary_network_interface_id, 0)
}

output "subnet_id" {
  description = "The ID of the VPC subnet of the monitoring host"
  value       = element(module.ec2_instance.subnet_id, 0)
}

output "vpc_security_group_ids" {
  description = "The associated security groups of the monitoring host"
  value       = module.ec2_instance.vpc_security_group_ids
}
