output "availability_zone" {
  description = "The availability zone of the bastion host"
  value       = element(module.ec2_instance.availability_zone, 0)
}

output "id" {
  description = "The instance ID of the bastion host"
  value       = element(module.ec2_instance.id, 0)
}

output "public_dns" {
  description = "The public DNS associated with the Elastic IP address"
  value       = module.ec2_instance.public_dns
}

output "public_ip" {
  description = "The public Elastic IP created for the bastion host"
  value       = module.ec2_instance.public_ip
}

output "primary_network_interface_id" {
  description = "The ID of the primary network interface"
  value       = element(module.ec2_instance.primary_network_interface_id, 0)
}

output "subnet_id" {
  description = "The ID of the VPC subnet of the bastion host"
  value       = element(module.ec2_instance.subnet_id, 0)
}

output "vpc_security_group_ids" {
  description = "The associated security groups of the bastion host"
  value       = module.ec2_instance.vpc_security_group_ids
}

output "route53_record_name" {
  description = "The name of the Route53 record"
  value       = aws_route53_record.a.name
}

output "route53_record_fqdn" {
  description = "The FQDN of the record"
  value       = aws_route53_record.a.fqdn
}
