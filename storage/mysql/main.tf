# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM STATE BLOCK
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}
}

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Only these AWS Account IDs may be operated on
  allowed_account_ids = var.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE RDS INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.34.0"

  identifier = "${var.name_prefix}-db"

  engine            = "mysql"
  engine_version    = var.mysql_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage
  storage_encrypted = true

  multi_az = var.multi_az

  name     = "imputationdb"
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  create_db_subnet_group = true
  db_subnet_group_description = "Database subnet group for ${var.name_prefix}-db"
  subnet_ids             = var.database_subnets

  option_group_description = "Option group for ${var.name_prefix}-db"

  parameter_group_description = "Database parameter group for ${var.name_prefix}-db"

  vpc_security_group_ids = [var.database_sg_id]

  major_engine_version = "5.7"
  family               = "mysql5.7"

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  backup_retention_period = var.backup_retention_period

  tags = var.tags
}
