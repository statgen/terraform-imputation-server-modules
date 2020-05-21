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

variable "vpc1" {
  description = "A VPC to add to the transit gateway"
  type        = string
  default     = null
}

variable "vpc1_subnets" {
  description = "List of subnets for VPC1"
  type        = list(string)
  default     = null
}

variable "vpc2" {
  description = "A VPC to add to the transit gateway"
  type        = string
  default     = null
}

variable "vpc2_subnets" {
  description = "List of subnets for VPC2"
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