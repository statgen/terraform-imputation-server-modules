# ---------------------------------------------------------------------------------------------------------------------
# CREATE TRANSIT GATEWAY
# ---------------------------------------------------------------------------------------------------------------------

module "transit_gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "1.4.0"

  name = "${var.name_prefix}-tgw"

  share_tgw = false

  vpc_attachments = {
    vpc1 = {
      vpc_id       = var.vpc1
      subnet_ids   = var.vpc1_subnets
      dns_support  = true
      ipv6_support = false
    },
    vpc2 = {
      vpc_id       = var.vpc2
      subnet_ids   = var.vpc2_subnets
      dns_support  = true
      ipv6_support = false
    }
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE TABLES FOR VPC SUBNETS/TRANSIT GATEWAY
# ---------------------------------------------------------------------------------------------------------------------

## Create route tables for MGMT VPC private subnets to APP VPC private subnets via transit gateway
resource "aws_route" "mgmt_vpc_to_app_vpc" {
  route_table_id         = var.mgmt_vpc_route_table_id
  destination_cidr_block = var.app_vpc_cidr_block
  transit_gateway_id     = module.transit_gateway.this_ec2_transit_gateway_id
}

## Create route tables for APP VPC private subnets to MGMT VPC private subnets via transit gateway
resource "aws_route" "app_vpc_to_mgmt_vpc" {
  count                  = 3
  route_table_id         = var.app_vpc_route_table_ids[count.index]
  destination_cidr_block = var.mgmt_vpc_cidr_block
  transit_gateway_id     = module.transit_gateway.this_ec2_transit_gateway_id
}
