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

variable "kms_alias" {
  description = "The display name of the KMS alias"
  type        = string
  default     = null
}

variable "kms_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 30
}

variable "kms_enable_key_rotation" {
  description = "Specifies whether KMS key rotation is enabled"
  type        = bool
  default     = true
}

variable "kms_is_enabled" {
  description = "Specifies whether the KMS key is enabled"
  type        = bool
  default     = true
}

variable "logs_bucket_name" {
  description = "The name of the S3 bucket for logs"
  type        = string
  default     = null
}

variable "access_logs_bucket_name" {
  description = "S3 bucket name for access logs of log bucket"
  type        = string
  default     = null
}

variable "imputation_server_bucket_name" {
  description = "S3 bucket name for imputation server"
  type        = string
  default     = null
}

variable "tld_redirect_bucket_name" {
  description = "S3 bucket name for TLD redirect. MUST BE EXACT TLD NAME!"
  type        = string
  default     = null
}

variable "tld_redirect_destination" {
  description = "The domain to which the TLD will redirect to eg: example.net"
  type        = string
  default     = null
}

variable "lifecycle_glacier_transition_days" {
  description = "The number of days after object creation when the object is archived into Glacier"
  type        = number
  default     = 120
}

variable "block_public_acls" {
  description = "Whether AWS S3 should block public ACLs for the S3 buckets"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether AWS S3 should block public policy for the S3 buckets"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether AWS S3 should ignore public ACLs for the S3 buckets"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether AWS S3 should restrict public bucket policies for the S3 buckets"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Whether AWS S3 should have versioning enabled on log buckets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
