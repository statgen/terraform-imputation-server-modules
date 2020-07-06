provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 2.6"

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
  required_version = "= 0.12.28"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE VPC
# ----------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = "${var.name_prefix}-app-vpc"
  cidr = var.cidr_block

  azs              = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_s3_endpoint = var.enable_s3_endpoint

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  create_database_internet_gateway_route = var.create_database_internet_gateway_route
  create_database_nat_gateway_route      = var.create_database_nat_gateway_route
  create_database_subnet_group           = var.create_database_subnet_group
  create_database_subnet_route_table     = var.create_database_subnet_route_table

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE VPC PEERING
# ----------------------------------------------------------------------------------------------------------------------

# locals {
#   tags = "${map("Name", "VPC Peering between ${var.peer_vpc_name} and ${module.vpc.name}")}"
# }

# resource "aws_vpc_peering_connection" "this" {
#   peer_vpc_id = var.peer_vpc_id
#   vpc_id      = module.vpc.vpc_id
#   auto_accept = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   tags = merge(local.tags, var.tags)
# }

# # Update route tables for VPC peering
# ## Create route tables between mgmt VPC public subnets and this VPC private subnets
# resource "aws_route" "vpc_peering_route_this_vpc0" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[0]
#   destination_cidr_block    = var.peer_vpc_public_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_this_vpc1" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[1]
#   destination_cidr_block    = var.peer_vpc_public_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_this_vpc2" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[2]
#   destination_cidr_block    = var.peer_vpc_public_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_mgmt_vpc0" {
#   count                     = 3
#   route_table_id            = var.peer_vpc_public_route_table_ids[0]
#   destination_cidr_block    = module.vpc.private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# ## Create route tables between mgmt VPC private subnets and this VPC private subnets
# resource "aws_route" "vpc_peering_route_this_vpc_private0" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[0]
#   destination_cidr_block    = var.peer_vpc_private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_this_vpc_private1" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[1]
#   destination_cidr_block    = var.peer_vpc_private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_this_vpc_private2" {
#   count                     = 3
#   route_table_id            = module.vpc.private_route_table_ids[2]
#   destination_cidr_block    = var.peer_vpc_private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_mgmt_vpc_private0" {
#   count                     = 3
#   route_table_id            = var.peer_vpc_private_route_table_ids[0]
#   destination_cidr_block    = module.vpc.private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_mgmt_vpc_private1" {
#   count                     = 3
#   route_table_id            = var.peer_vpc_private_route_table_ids[1]
#   destination_cidr_block    = module.vpc.private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }

# resource "aws_route" "vpc_peering_route_mgmt_vpc_private2" {
#   count                     = 3
#   route_table_id            = var.peer_vpc_private_route_table_ids[2]
#   destination_cidr_block    = module.vpc.private_subnets_cidr_blocks[count.index]
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# }
