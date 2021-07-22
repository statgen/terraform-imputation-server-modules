variable "bucket_name" {
  description = "The name of the S3 bucket where objects will be uploaded"
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
