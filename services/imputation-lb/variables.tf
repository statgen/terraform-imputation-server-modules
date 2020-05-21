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

variable "domain" {
  description = "The FQDN of the domain to which the cerficate is attached"
  type        = string
  default     = null
}

variable "enable_https" {
  description = "Enable HTTPS on ELB"
  type        = bool
  default     = false
}

variable "lb_security_group" {
  description = "security group for ELB"
  type        = string
  default     = null
}

variable "lb_subnets" {
  description = "The subnet where the ELB will be deployed"
  type        = list(string)
  default     = null
}

variable "master_node_id" {
  description = "EMR master node ID"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC in which the cluster is deployed"
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
