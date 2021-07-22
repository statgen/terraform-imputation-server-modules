variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness accross acounts"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for monitoring hosts"
  type        = string
  default     = "m5a.xlarge"
}

variable "root_volume_size" {
  description = "Root volume size for monitoring hosts in GB"
  type        = string
  default     = "500"
}

variable "monitoring_sg_id" {
  description = "The security group ID monitoring hosts"
  type        = string
  default     = null
}

variable "private_subnets" {
  description = "A list of private subnets for the monitoring hosts"
  type        = list(string)
  default     = null
}

variable "monitoring_host_instance_profile_name" {
  description = "The instance profile for that monitoring host to assume"
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
