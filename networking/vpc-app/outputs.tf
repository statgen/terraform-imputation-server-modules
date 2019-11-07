# ---------------------------------------------------------------------------------------------------------------------
# VPC OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = module.vpc.database_network_acl_id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = module.vpc.database_route_table_ids
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.vpc.database_subnet_arns
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.vpc.database_subnet_group
}

output "database_subnets" {
  description = "List of ids of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks of database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

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
  value       = aws_flow_log.this.id
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC PEERING CONNECTION OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.this.id
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "database_sg_arn" {
  description = "The ARN of the database security group"
  value       = aws_security_group.database.arn
}

output "database_sg_description" {
  description = "The description of the database security group"
  value       = aws_security_group.database.description
}

output "database_sg_egress" {
  description = "The egress rules for the database security group"
  value       = aws_security_group.database.egress
}

output "database_sg_ingress" {
  description = "The ingress rules for the database security group"
  value       = aws_security_group.database.ingress
}

output "database_sg_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.database.id
}

output "database_sg_name" {
  description = "The name of the database security group"
  value       = aws_security_group.database.name
}

output "database_sg_owner_id" {
  description = "The owner ID of the database security group"
  value       = aws_security_group.database.owner_id
}

output "database_sg_vpc_id" {
  description = "The VPC ID of the database security group"
  value       = aws_security_group.database.vpc_id
}

output "lb_sg_arn" {
  description = "The ARN of the load balancer security group"
  value       = aws_security_group.lb.arn
}

output "lb_sg_description" {
  description = "The description of the load balancer security group"
  value       = aws_security_group.lb.description
}

output "lb_sg_egress" {
  description = "The egress rules for the load balancer security group"
  value       = aws_security_group.lb.egress
}

output "lb_sg_ingress" {
  description = "The ingress rules for the load balancer security group"
  value       = aws_security_group.lb.ingress
}

output "lb_sg_id" {
  description = "The ID of the load balancer security group"
  value       = aws_security_group.lb.id
}

output "lb_sg_name" {
  description = "The name of the load balancer security group"
  value       = aws_security_group.lb.name
}

output "lb_sg_owner_id" {
  description = "The owner ID of the load balancer security group"
  value       = aws_security_group.lb.owner_id
}

output "lb_sg_vpc_id" {
  description = "The VPC ID of the load balancer security group"
  value       = aws_security_group.lb.vpc_id
}

output "emr_master_sg_arn" {
  description = "The ARN of the EMR master security group"
  value       = aws_security_group.emr_master.arn
}

output "emr_master_sg_description" {
  description = "The description of the EMR master security group"
  value       = aws_security_group.emr_master.description
}

output "emr_master_sg_egress" {
  description = "The egress rules for the EMR master security group"
  value       = aws_security_group.emr_master.egress
}

output "emr_master_sg_ingress" {
  description = "The ingress rules for the EMR master security group"
  value       = aws_security_group.emr_master.ingress
}

output "emr_master_sg_id" {
  description = "The ID of the EMR master security group"
  value       = aws_security_group.emr_master.id
}

output "emr_master_sg_name" {
  description = "The name of the EMR master security group"
  value       = aws_security_group.emr_master.name
}

output "emr_master_sg_owner_id" {
  description = "The owner ID of the EMR master security group"
  value       = aws_security_group.emr_master.owner_id
}

output "emr_master_sg_vpc_id" {
  description = "The VPC ID of the EMR master security group"
  value       = aws_security_group.emr_master.vpc_id
}

output "emr_slave_sg_arn" {
  description = "The ARN of the EMR slave security group"
  value       = aws_security_group.emr_slave.arn
}

output "emr_slave_sg_description" {
  description = "The description of the EMR slave security group"
  value       = aws_security_group.emr_slave.description
}

output "emr_slave_sg_egress" {
  description = "The egress rules for the EMR slave security group"
  value       = aws_security_group.emr_slave.egress
}

output "emr_slave_sg_ingress" {
  description = "The ingress rules for the EMR slave security group"
  value       = aws_security_group.emr_slave.ingress
}

output "emr_slave_sg_id" {
  description = "The ID of the EMR slave security group"
  value       = aws_security_group.emr_slave.id
}

output "emr_slave_sg_name" {
  description = "The name of the EMR slave security group"
  value       = aws_security_group.emr_slave.name
}

output "emr_slave_sg_owner_id" {
  description = "The owner ID of the EMR slave security group"
  value       = aws_security_group.emr_slave.owner_id
}

output "emr_slave_sg_vpc_id" {
  description = "The VPC ID of the EMR slave security group"
  value       = aws_security_group.emr_slave.vpc_id
}

output "emr_service_sg_arn" {
  description = "The ARN of the EMR service security group"
  value       = aws_security_group.emr_service.arn
}

output "emr_service_sg_description" {
  description = "The description of the EMR service security group"
  value       = aws_security_group.emr_service.description
}

output "emr_service_sg_egress" {
  description = "The egress rules for the EMR service security group"
  value       = aws_security_group.emr_service.egress
}

output "emr_service_sg_ingress" {
  description = "The ingress rules for the EMR service security group"
  value       = aws_security_group.emr_service.ingress
}

output "emr_service_sg_id" {
  description = "The ID of the EMR service security group"
  value       = aws_security_group.emr_service.id
}

output "emr_service_sg_name" {
  description = "The name of the EMR service security group"
  value       = aws_security_group.emr_service.name
}

output "emr_service_sg_owner_id" {
  description = "The owner ID of the EMR service security group"
  value       = aws_security_group.emr_service.owner_id
}

output "emr_service_sg_vpc_id" {
  description = "The VPC ID of the EMR service security group"
  value       = aws_security_group.emr_service.vpc_id
}
