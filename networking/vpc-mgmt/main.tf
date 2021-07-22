# ----------------------------------------------------------------------------------------------------------------------
# CREATE VPC
# ----------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "${var.name_prefix}-mgmt-vpc"
  cidr = var.cidr_block

  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = var.tags
}
