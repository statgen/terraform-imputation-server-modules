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

variable "aws_account_alias" {
  description = "The IAM Account Alias"
  type        = string
  default     = null
}

variable "group_memberships" {
  description = "Map of users and their group memberships"
  type        = map(list(string))
  default     = null
}

variable "user_names" {
  description = "Map of users and their attributes"
  type        = map(map(string))
  default     = null
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
