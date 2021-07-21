variable "is_enabled" {
  description = "If AWS config is enabled or not"
  type        = bool
  default     = true
}

variable "config_bucket_name" {
  description = "The name of the s3 bucket for aws config results"
  type        = string
  default     = null
}

variable "config_bucket_kms_arn" {
  description = "The ARN of the KMS key for encrypting/decrypting the AWS Config S3 bucket"
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
