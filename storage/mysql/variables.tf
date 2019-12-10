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

variable "db_password" {
  description = "Password for mySQL database"
  type        = string
  default     = null
}

variable "database_subnets" {
  description = "A list of subnets for the RDS instance"
  type        = list(string)
  default     = null
}

variable "database_sg_id" {
  description = "The ID of the database security group"
  type        = string
  default     = null
}

variable "emr_master_sg_id" {
  description = "The ID of the EMR master security group"
  type        = string
  default     = null
}

variable "mysql_engine_version" {
  description = "MySQL engine verison"
  type        = string
  default     = "5.7.22"
}

variable "db_instance_class" {
  description = "DB instance class type"
  type        = string
  default     = "db.t3.medium"
}

variable "db_storage" {
  description = "Amount of storage for database in GB"
  type        = string
  default     = "32"
}

variable "db_username" {
  description = "Username for database"
  type        = string
  default     = "imputationuser"
}

variable "db_port" {
  description = "Port for database connection"
  type        = string
  default     = "3306"
}

variable "maintenance_window" {
  description = "Maintenance window for DB upgrade performed by AWS"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "Backup window for automatic DB backups"
  type        = string
  default     = "03:00-06:00"
}

variable "backup_retention_period" {
  description = "Number for days to keep backups"
  type        = string
  default     = "30"
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
