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
  default     = "10.100.0.0/16"
}

variable "private_subnets" {
  description = "A list of CIDR ranges for private subnets in 3 AZs"
  type        = list(string)
  default     = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"]
}
variable "public_subnets" {
  description = "A list of CIDR ranges for public subnets in 3 AZs"
  type        = list(string)
  default     = ["10.100.3.0/24", "10.100.4.0/24", "10.100.5.0/24"]
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

variable "enable_nat_gateway" {
  description = "Create NAT gateways for private subnets"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Create one shared NAT gateway for all AZs"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Create a NAT gateway for each AZ"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "S3 bucket for VPC flow logs"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
