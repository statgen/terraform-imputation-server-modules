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

variable "allowed_cidr_ranges" {
  description = "List of CIDR blocks to allow incoming SSH"
  type        = list(string)
  default     = null
}

variable "app_vpc_id" {
  description = "The VPC ID of the application VPC"
  type        = string
  default     = null
}

variable "mgmt_vpc_id" {
  description = "The VPC ID of the managemnt VPC"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness accross acounts"
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
