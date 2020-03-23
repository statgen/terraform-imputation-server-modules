output "bastion_host_sg_arn" {
  description = "The ARN of the bastion host security group"
  value       = aws_security_group.bastion_host.arn
}

output "bastion_host_sg_description" {
  description = "The description of the bastion host security group"
  value       = aws_security_group.bastion_host.description
}

output "bastion_host_sg_egress" {
  description = "The egress rules for the bastion host security group"
  value       = aws_security_group.bastion_host.egress
}

output "bastion_host_sg_ingress" {
  description = "The ingress rules for the bastion host security group"
  value       = aws_security_group.bastion_host.ingress
}

output "bastion_host_sg_id" {
  description = "The ID of the bastion host security group"
  value       = aws_security_group.bastion_host.id
}

output "bastion_host_sg_name" {
  description = "The name of the bastion host security group"
  value       = aws_security_group.bastion_host.name
}

output "bastion_host_sg_owner_id" {
  description = "The owner ID of the bastion host security group"
  value       = aws_security_group.bastion_host.owner_id
}

output "bastion_host_sg_vpc_id" {
  description = "The VPC ID of the bastion host security group"
  value       = aws_security_group.bastion_host.vpc_id
}

output "monitoring_hosts_sg_arn" {
  description = "The ARN of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.arn
}

output "monitoring_hosts_sg_description" {
  description = "The description of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.description
}

output "monitoring_hosts_sg_egress" {
  description = "The egress rules for the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.egress
}

output "monitoring_hosts_sg_ingress" {
  description = "The ingress rules for the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.ingress
}

output "monitoring_hosts_sg_id" {
  description = "The ID of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.id
}

output "monitoring_hosts_sg_name" {
  description = "The name of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.name
}

output "monitoring_hosts_sg_owner_id" {
  description = "The owner ID of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.owner_id
}

output "monitoring_hosts_sg_vpc_id" {
  description = "The VPC ID of the monitoring hosts security group"
  value       = aws_security_group.monitoring_hosts.vpc_id
}

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
  value       = aws_security_group.imputation_lb.arn
}

output "lb_sg_description" {
  description = "The description of the load balancer security group"
  value       = aws_security_group.imputation_lb.description
}

output "lb_sg_egress" {
  description = "The egress rules for the load balancer security group"
  value       = aws_security_group.imputation_lb.egress
}

output "lb_sg_ingress" {
  description = "The ingress rules for the load balancer security group"
  value       = aws_security_group.imputation_lb.ingress
}

output "lb_sg_id" {
  description = "The ID of the load balancer security group"
  value       = aws_security_group.imputation_lb.id
}

output "lb_sg_name" {
  description = "The name of the load balancer security group"
  value       = aws_security_group.imputation_lb.name
}

output "lb_sg_owner_id" {
  description = "The owner ID of the load balancer security group"
  value       = aws_security_group.imputation_lb.owner_id
}

output "lb_sg_vpc_id" {
  description = "The VPC ID of the load balancer security group"
  value       = aws_security_group.imputation_lb.vpc_id
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
