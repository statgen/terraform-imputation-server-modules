# ---------------------------------------------------------------------------------------------------------------------
# VPC OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateways"
  value       = module.vpc.nat_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs create for AWS NAT Gateways"
  value       = module.vpc.nat_public_ips
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = module.vpc.private_network_acl_id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "private_subnets" {
  description = "List of ids of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = module.vpc.public_network_acl_id
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.vpc.public_subnet_arns
}

output "public_subnets" {
  description = "List of ids of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_azs" {
  description = "A list of availability zones this VPC spans"
  value       = module.vpc.azs
}

output "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_enable_dns_hostnames" {
  description = "Wheather or not the VPC has DNS hostname support"
  value       = module.vpc.vpc_enable_dns_hostnames
}

output "vpc_id" {
  description = "The id of the vpc"
  value       = module.vpc.vpc_id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the VPC"
  value       = module.vpc.vpc_main_route_table_id
}

output "vpc_name" {
  description = "The name of the VPC as specified"
  value       = module.vpc.name
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC FLOW LOG OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_flow_log_id" {
  description = "The Flow Log ID"
  value       = aws_flow_log.vpc_flow_log.id
}
