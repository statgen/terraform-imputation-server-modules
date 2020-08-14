provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 3.2"

  # Only these AWS Account IDs may be operated on
  allowed_account_ids = var.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM STATE BLOCK
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}

  # Only allow this Terraform version. Note that if you upgrade to a newer version, Terraform won't allow you to use an
  # older version, so when you upgrade, you should upgrade everyone on your team and your CI servers all at once.
  required_version = ">= 0.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SECURITY GROUPS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "bastion_host" {
  name        = "${var.name_prefix}-bastion-host"
  description = "Security group for bastion host EC2 instance"
  vpc_id      = var.mgmt_vpc_id

  tags = var.tags
}

resource "aws_security_group" "monitoring_hosts" {
  name        = "${var.name_prefix}-monitoring-hosts"
  description = "Security group for monitoring hosts"
  vpc_id      = var.mgmt_vpc_id

  tags = var.tags
}

resource "aws_security_group" "imputation_lb" {
  name        = "${var.name_prefix}-imputation-lb"
  description = "Security group for the front-end load balancer"
  vpc_id      = var.app_vpc_id

  tags = var.tags
}

resource "aws_security_group" "database" {
  name        = "${var.name_prefix}-database"
  description = "Security group for the database instance"
  vpc_id      = var.app_vpc_id

  tags = var.tags
}

resource "aws_security_group" "emr_master" {
  name        = "${var.name_prefix}-emr-master"
  description = "Security group for the EMR master node(s)"
  vpc_id      = var.app_vpc_id

  revoke_rules_on_delete = true

  tags = var.tags
}

resource "aws_security_group" "emr_slave" {
  name        = "${var.name_prefix}-emr-slave"
  description = "Security group for the EMR slave nodes"
  vpc_id      = var.app_vpc_id

  revoke_rules_on_delete = true

  tags = var.tags
}

resource "aws_security_group" "emr_service" {
  name        = "${var.name_prefix}-emr-service"
  description = "Security group for EMR service access"
  vpc_id      = var.app_vpc_id

  revoke_rules_on_delete = true

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE BASTION-HOST SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "bastion_host_ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.allowed_cidr_ranges

  description = "Allow ingress SSH to bastion host from CIDR range"

  security_group_id = aws_security_group.bastion_host.id
}

resource "aws_security_group_rule" "bastion_host_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bastion_host.id
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE BASTION-HOST SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "monitoring_hosts_emr_master_prometheus_ingress" {
  type      = "ingress"
  from_port = "9090"
  to_port   = "9106"
  protocol  = "tcp"
  # source_security_group_id = aws_security_group.emr_master.id
  cidr_blocks = var.app_vpc_private_subnets_cidr

  description = "Allow ingress Prometheus monitoring stats from EMR master security group"

  security_group_id = aws_security_group.monitoring_hosts.id
}

# Duplicate when using CIDR blocks rather than secuirty group IDs. Leaving in place for 
# future support of ref. security group ID across transit gateways
# resource "aws_security_group_rule" "monitoring_hosts_emr_slave_prometheus_ingress" {
#   type      = "ingress"
#   from_port = "9090"
#   to_port   = "9106"
#   protocol  = "tcp"
#   # source_security_group_id = aws_security_group.emr_slave.id
#   cidr_blocks = var.app_vpc_private_subnets_cidr

#   description = "Allow ingress Prometheus monitoring stats from EMR slave security group"

#   security_group_id = aws_security_group.monitoring_hosts.id
# }

resource "aws_security_group_rule" "monitoring_hosts_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.monitoring_hosts.id
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE DATABASE SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "mysql_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_master.id

  description = "Allow ingress mysql traffic on port 3306 from EMR master security group"

  security_group_id = aws_security_group.database.id
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION SERVER SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "emr_master_ssh_ingress" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  #source_security_group_id = aws_security_group.bastion_host.id
  cidr_blocks = var.mgmt_vpc_private_subnets_cidr

  description = "Allow ingress SSH from bastion host"

  security_group_id = aws_security_group.emr_master.id
}

resource "aws_security_group_rule" "emr_master_imputation_ingress" {
  type                     = "ingress"
  from_port                = 8082
  to_port                  = 8082
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.imputation_lb.id

  description = "Allow ingress HTTP traffic on port 8082 from ELB"

  security_group_id = aws_security_group.emr_master.id
}

resource "aws_security_group_rule" "emr_master_prometheus_ingress" {
  type      = "ingress"
  from_port = "9090"
  to_port   = "9106"
  protocol  = "tcp"
  # source_security_group_id = aws_security_group.monitoring_hosts.id
  cidr_blocks = var.mgmt_vpc_private_subnets_cidr

  description = "Allow ingress Prometheus monitoring stats ingress from monitoring group"

  security_group_id = aws_security_group.emr_master.id
}

resource "aws_security_group_rule" "emr_slave_prometheus_ingress" {
  type      = "ingress"
  from_port = "9090"
  to_port   = "9106"
  protocol  = "tcp"
  # source_security_group_id = aws_security_group.monitoring_hosts.id
  cidr_blocks = var.mgmt_vpc_private_subnets_cidr

  description = "Allow ingress Prometheus monitoring stats ingress from monitoring group"

  security_group_id = aws_security_group.emr_slave.id
}

resource "aws_security_group_rule" "emr_master_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all egress traffic"

  security_group_id = aws_security_group.emr_master.id
}

resource "aws_security_group_rule" "emr_slave_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all egress traffic"

  security_group_id = aws_security_group.emr_slave.id
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION LB SECURITY GROUP RULES
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "lb_http_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow ingress HTTP traffic on port 80 from all"

  security_group_id = aws_security_group.imputation_lb.id
}

resource "aws_security_group_rule" "lb_https_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow ingress HTTPS traffic on port 443 from all"

  security_group_id = aws_security_group.imputation_lb.id
}

resource "aws_security_group_rule" "lb_http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_master.id

  description = "Allow egress HTTP traffic on port 80 to EMR cluster security group"

  security_group_id = aws_security_group.imputation_lb.id
}

resource "aws_security_group_rule" "lb_https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_master.id

  description = "Allow egress HTTPS traffic on port 443 to EMR cluster security group"

  security_group_id = aws_security_group.imputation_lb.id
}

resource "aws_security_group_rule" "lb_imputation_egress" {
  type                     = "egress"
  from_port                = 8082
  to_port                  = 8082
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_master.id

  description = "Allow egress HTTP traffic on port 8082 to EMR cluster security group"

  security_group_id = aws_security_group.imputation_lb.id
}

resource "aws_security_group_rule" "lb_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all egress traffic"

  security_group_id = aws_security_group.imputation_lb.id
}
