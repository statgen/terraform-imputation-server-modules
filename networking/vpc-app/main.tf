# ----------------------------------------------------------------------------------------------------------------------
# CREATE VPC
# ----------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}

module "vpc" {
  providers = {
  }
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

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
