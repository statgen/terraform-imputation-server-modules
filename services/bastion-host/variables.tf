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
  description = "A name prefix used in resource names to ensure uniqueness accross acounts"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t2.micro"
}

variable "root_volume_size" {
  description = "Root volume size for bastion host in GB"
  type        = string
  default     = "64"
}

variable "bastion_host_sg_id" {
  description = "The security group ID for the bastion host"
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "A list of public subnets for the bastion host"
  type        = list(string)
  default     = null
}

variable "bastion_host_instance_profile_name" {
  description = "The instance profile for that bastion host to assume"
  type        = string
  default     = null
}

variable "allowed_cidr_ranges" {
  description = "A list of CIDR blocks that are allowed for incoming SSH connections"
  type        = list(string)
  default     = null
}

variable "mgmt_route53_zone_id" {
  description = "The Zone to create the bastion host DNS entry"
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
