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

variable "public_key" {
  description = "Public key for AWS key pair for EMR cluster"
  default     = null
  type        = string
}

variable "ec2_subnet" {
  description = "The subnet to place EC2 instances in"
  type        = list(string)
  default     = null
}

variable "emr_managed_master_security_group" {
  description = "Managed security group for EMR cluster master node(s)"
  type        = string
  default     = null
}

variable "emr_managed_slave_security_group" {
  description = "Managed security group for EMR cluster slave nodes"
  type        = string
  default     = null
}

variable "service_access_security_group" {
  description = "EC2 service access security group for EMR cluster in private subnet"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC in which the cluster is deployed"
  type        = string
  default     = null
}

variable "emr_release_label" {
  description = "The EMR release version to use"
  type        = string
  default     = "null"
}

variable "bootstrap_action" {
  description = "List of bootstrap actions that will be run before Hadoop is started on the cluster"
  default     = []
  type        = list(object({ name : string, path : string, args : list(string) }))
  # example:
  # bootstrap_action = [{
  #   name = "imputation-bootstrap"
  #   path = "s3://imputationserver-aws/bootstrap.sh"
  #   args = []
  # },]
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
