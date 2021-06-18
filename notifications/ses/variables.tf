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

variable "domain" {
  description = "The domain to be used for SES identity"
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
