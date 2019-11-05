variable "aws_region" {
  description = "The AWS region in which all resources will be created"
  type        = string
  default     = null
}

variable "aws_account_id" {
  description = "The ID of the AWS account in which all resources will be created"
  type        = list(string)
  default     = null
}

variable "name_prefix" {
  description = "A name prefix used in resource names"
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = "10.120.0.0/16"
}

variable "private_subnets" {
  description = "A list of CIDR ranges for private subnets in 3 AZs"
  type        = list(string)
  default     = ["10.120.0.0/20", "10.120.16.0/20", "10.120.32.0/20"]
}

variable "public_subnets" {
  description = "A list of CIDR ranges for public subnets in 3 AZs"
  type        = list(string)
  default     = ["10.120.48.0/20", "10.120.64.0/20", "10.120.80.0/20"]
}

variable "database_subnets" {
  description = "A list of CIDR ranges for public subents in 3 AZs"
  type        = list(string)
  default     = ["10.120.96.0/24", "10.120.97.0/24", "10.120.98.0/24"]
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostname support in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Enable S3 endpoint in VPC for S3 traffic"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Create one shared NAT gateway for all AZs"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Create a NAT gateway for each AZ"
  type        = bool
  default     = true
}

variable "create_database_internet_gateway_route" {
  description = "Create route table entry for database subnets to internet"
  type        = bool
  default     = false
}

variable "create_database_nat_gateway_route" {
  description = "Create route table entry for database subnets to NAT gateway"
  type        = bool
  default     = false
}

variable "create_database_subnet_group" {
  description = "Create database subnet group for RDS instances"
  type        = bool
  default     = false
}

variable "create_database_subnet_route_table" {
  description = "Create seperate route table for database subnets"
  type        = bool
  default     = true
}

variable "log_bucket" {
  description = "S3 bucket for VPC flow logs"
  type        = string
  default     = null
}

variable "peer_vpc_id" {
  description = "The ID of the VPC to be peered"
  type        = "string"
  default     = null
}

variable "peer_vpc_name" {
  description = "The name of the VPC to be peered"
  type        = string
  default     = null
}

variable "peer_vpc_public_subnets_cidr_blocks" {
  description = "A list of CIDR blocks of public subnets from the peer VPC"
  type        = list(string)
  default     = null
}

variable "peer_vpc_private_subnets_cidr_blocks" {
  description = "A list of CIDR blocks of private subnets from the peer VPC"
  type        = list(string)
  default     = null
}

variable "peer_vpc_public_route_table_ids" {
  description = "A list of route tables of public subnets from the peer VPC"
  type        = list(string)
  default     = null
}

variable "peer_vpc_private_route_table_ids" {
  description = "A list of route tables of private subnets from the peer VPC"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
