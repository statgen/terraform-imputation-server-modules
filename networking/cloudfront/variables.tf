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

variable "sub_domain" {
  description = "TLD or subdomain used in cloudfront and route53 setup"
  type        = string
  default     = null
}

variable "lb_dns_name" {
  description = "The DNS name of the loadbalancer to be used for the cloufront origin"
  type        = string
  default     = null
}

variable "log_bucket" {
  description = "S3 bucket to be used for cloudfront logs"
  type        = string
  default     = null
}

variable "lambda_edge_role_arn" {
  description = "The IAM role to be used for Lambda @ Edge permissions"
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "The route53 zone ID of the zone for the DNS record to be created in"
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
