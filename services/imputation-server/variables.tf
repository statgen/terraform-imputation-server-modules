# Global 

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across accounts"
  type        = string
  default     = null
}

variable "enable_green_application" {
  description = "Enable Green application of Blue/Green deployments"
  type        = bool
  default     = false
}

variable "enable_blue_application" {
  description = "Enable Blue application of Blue/Green deployments"
  type        = bool
  default     = false
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
  default     = "blue"
}

variable "lb_security_group" {
  description = "Security group for ALB"
  type        = string
  default     = null
}

variable "lb_subnets" {
  description = "The subnet where the ALB will be deployed"
  type        = list(string)
  default     = null
}

variable "domain" {
  description = "The FQDN of the domain to which the ALB listener certificate is attached"
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

# Blue environment
variable "backend_port_blue" {
  description = "The port to use in the target group to connect with the target"
  type        = string
  default     = 8082
}

variable "custom_ami_id_blue" {
  description = "A custom AMI for the EMR cluster"
  type        = string
  default     = null
}

variable "public_key_blue" {
  description = "Public key for AWS key pair for EMR cluster"
  default     = null
  type        = string
}

variable "ec2_subnet_blue" {
  description = "The subnet to place EC2 instances in"
  type        = list(string)
  default     = null
}

variable "ec2_autoscaling_role_name_blue" {
  description = "The name of the role for EC2 instance autoscaling"
  type        = string
  default     = null
}

variable "ec2_role_arn_blue" {
  description = "The ARN of the role for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "ec2_instance_profile_name_blue" {
  description = "The name of the instance profile for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_arn_blue" {
  description = "The ARN of the role for the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_name_blue" {
  description = "The name of the role for the EMR cluster"
  type        = string
  default     = null
}

variable "emr_managed_master_security_group_blue" {
  description = "Managed security group for EMR cluster master node(s)"
  type        = string
  default     = null
}

variable "emr_managed_slave_security_group_blue" {
  description = "Managed security group for EMR cluster slave nodes"
  type        = string
  default     = null
}

variable "service_access_security_group_blue" {
  description = "EC2 service access security group for EMR cluster in private subnet"
  type        = string
  default     = null
}

variable "vpc_id_blue" {
  description = "The ID of the VPC in which the cluster is deployed"
  type        = string
  default     = null
}

variable "emr_release_label_blue" {
  description = "The EMR release version to use"
  type        = string
  default     = "null"
}

variable "log_uri_blue" {
  description = "The S3 bucket to which logs will be written"
  type        = string
  default     = null
}

variable "bootstrap_action_blue" {
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

variable "core_instance_count_max_blue" {
  description = "Max capacity for core instance ASG"
  type        = number
  default     = 10
}

variable "core_instance_count_min_blue" {
  description = "Min capacity for core instance ASG"
  type        = number
  default     = 6
}

variable "core_instance_ebs_size_blue" {
  description = "Size for EBS disk on core instances in GB"
  type        = string
  default     = ""
}

variable "core_instance_type_blue" {
  description = "Core instance type for EMR"
  type        = string
  default     = "i3en.2xlarge"
}

variable "master_instance_ebs_size_blue" {
  description = "Size for EBS disk on master instance in GB"
  type        = string
  default     = ""
}

variable "master_instance_type_blue" {
  description = "Instance type for EMR master node"
  type        = string
  default     = "i3en.6xlarge"
}

variable "task_instance_count_max_blue" {
  description = "Max capacity for task instance ASG"
  type        = number
  default     = 50
}

variable "task_instance_count_min_blue" {
  description = "Min capacity for task instance ASG"
  type        = number
  default     = 3
}

variable "task_instance_ebs_size_blue" {
  description = "Size for EBS disk on task instances in GB"
  type        = string
  default     = ""
}

variable "task_instance_type_blue" {
  description = "Task instance type for EMR"
  type        = string
  default     = "r5.24xlarge"
}

# Green environment
variable "backend_port_green" {
  description = "The port to use in the target group to connect with the target"
  type        = string
  default     = 8082
}

variable "custom_ami_id_green" {
  description = "A custom AMI for the EMR cluster"
  type        = string
  default     = null
}

variable "public_key_green" {
  description = "Public key for AWS key pair for EMR cluster"
  default     = null
  type        = string
}

variable "ec2_subnet_green" {
  description = "The subnet to place EC2 instances in"
  type        = list(string)
  default     = null
}

variable "ec2_autoscaling_role_name_green" {
  description = "The name of the role for EC2 instance autoscaling"
  type        = string
  default     = null
}

variable "ec2_role_arn_green" {
  description = "The ARN of the role for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "ec2_instance_profile_name_green" {
  description = "The name of the instance profile for the EC2 instances in the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_arn_green" {
  description = "The ARN of the role for the EMR cluster"
  type        = string
  default     = null
}

variable "emr_role_name_green" {
  description = "The name of the role for the EMR cluster"
  type        = string
  default     = null
}

variable "emr_managed_master_security_group_green" {
  description = "Managed security group for EMR cluster master node(s)"
  type        = string
  default     = null
}

variable "emr_managed_slave_security_group_green" {
  description = "Managed security group for EMR cluster slave nodes"
  type        = string
  default     = null
}

variable "service_access_security_group_green" {
  description = "EC2 service access security group for EMR cluster in private subnet"
  type        = string
  default     = null
}

variable "vpc_id_green" {
  description = "The ID of the VPC in which the cluster is deployed"
  type        = string
  default     = null
}

variable "emr_release_label_green" {
  description = "The EMR release version to use"
  type        = string
  default     = "null"
}

variable "log_uri_green" {
  description = "The S3 bucket to which logs will be written"
  type        = string
  default     = null
}

variable "bootstrap_action_green" {
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

variable "core_instance_count_max_green" {
  description = "Max capacity for core instance ASG"
  type        = number
  default     = 10
}

variable "core_instance_count_min_green" {
  description = "Min capacity for core instance ASG"
  type        = number
  default     = 6
}

variable "core_instance_ebs_size_green" {
  description = "Size for EBS disk on core instances in GB"
  type        = string
  default     = ""
}

variable "core_instance_type_green" {
  description = "Core instance type for EMR"
  type        = string
  default     = "i3en.2xlarge"
}

variable "master_instance_ebs_size_green" {
  description = "Size for EBS disk on master instance in GB"
  type        = string
  default     = ""
}

variable "master_instance_type_green" {
  description = "Instance type for EMR master node"
  type        = string
  default     = "i3en.6xlarge"
}

variable "task_instance_count_max_green" {
  description = "Max capacity for task instance ASG"
  type        = number
  default     = 50
}

variable "task_instance_count_min_green" {
  description = "Min capacity for task instance ASG"
  type        = number
  default     = 3
}

variable "task_instance_ebs_size_green" {
  description = "Size for EBS disk on task instances in GB"
  type        = string
  default     = ""
}

variable "task_instance_type_green" {
  description = "Task instance type for EMR"
  type        = string
  default     = "r5.24xlarge"
}
