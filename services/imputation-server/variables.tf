variable "custom_ami_id" {
  description = "A custom AMI for the EMR cluster"
  type        = string
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

variable "ec2_autoscaling_role_name" {
  description = "The name of the role for EC2 instance autoscaling"
  type        = string
  default     = null
}

variable "ec2_role_arn" {
  description = "The ARN of the role for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "ec2_instance_profile_name" {
  description = "The name of the instance profile for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_arn" {
  description = "The ARN of the role for the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_name" {
  description = "The name of the role for the EMR cluster"
  type        = string
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

variable "log_uri" {
  description = "The S3 bucket to which logs will be written"
  type        = string
  default     = null
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

variable "core_instance_count_max" {
  description = "Max capacity for core instance ASG"
  type        = number
  default     = 10
}

variable "core_instance_count_min" {
  description = "Min capacity for core instance ASG"
  type        = number
  default     = 6
}

variable "core_instance_ebs_size" {
  description = "Size for EBS disk on core instances in GB"
  type        = string
  default     = "2048"
}

variable "core_instance_type" {
  description = "Core instance type for EMR"
  type        = string
  default     = "r5.2xlarge"
}

variable "master_instance_ebs_size" {
  description = "Size for EBS disk on master instance in GB"
  type        = string
  default     = "4096"
}

variable "master_instance_type" {
  description = "Instance type for EMR master node"
  type        = string
  default     = "r5.4xlarge"
}

variable "task_instance_count_max" {
  description = "Max capacity for task instance ASG"
  type        = number
  default     = 50
}

variable "task_instance_count_min" {
  description = "Min capacity for task instance ASG"
  type        = number
  default     = 3
}

variable "task_instance_ebs_size" {
  description = "Size for EBS disk on task instances in GB"
  type        = string
  default     = "2048"
}

variable "task_instance_type" {
  description = "Task instance type for EMR"
  type        = string
  default     = "r5.24xlarge"
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
