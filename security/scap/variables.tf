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

variable "enable_security_hub_findings" {
  description = "Deterimines if Security Hub is used by the ProcessSCAPScanResult Lambda Function"
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

variable "scap_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = null
}

variable "scap_profile_name" {
  description = "The SCAP profile name that will be used in the Lambda function for parsing"
  type        = string
  default     = null
}

variable "scap_script_name" {
  description = "Name of the script run by SSM to init SCAP"
  type        = string
  default     = "scapInit.sh"
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
