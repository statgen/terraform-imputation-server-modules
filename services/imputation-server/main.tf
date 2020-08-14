provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Require a 2.x version of the AWS provider
  version = "~> 2.6"

  # Only these AWS Account IDs may be operated on
  allowed_account_ids = var.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM STATE BLOCK
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt or via a backend.hcl file. See
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "s3" {}

  # Only allow this Terraform version. Note that if you upgrade to a newer version, Terraform won't allow you to use an
  # older version, so when you upgrade, you should upgrade everyone on your team and your CI servers all at once.
  required_version = ">= 0.13"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION SERVER EMR CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

locals {
  ec2_subnet = element(var.ec2_subnet, 0)
}

module "imputation-server" {
  source = "github.com/jdpleiness/terraform-aws-imputation-server.git//modules/imputation-server"

  name_prefix = var.name_prefix

  vpc_id                            = var.vpc_id
  ec2_subnet                        = local.ec2_subnet
  emr_managed_master_security_group = var.emr_managed_master_security_group
  emr_managed_slave_security_group  = var.emr_managed_slave_security_group
  service_access_security_group     = var.service_access_security_group

  ec2_autoscaling_role_name = var.ec2_autoscaling_role_name
  ec2_role_arn              = var.ec2_role_arn
  ec2_instance_profile_name = var.ec2_instance_profile_name
  emr_role_arn              = var.emr_role_arn
  emr_role_name             = var.emr_role_name
  emr_release_label         = var.emr_release_label
  log_uri                   = var.log_uri

  master_instance_type     = var.master_instance_type
  master_instance_ebs_size = var.master_instance_ebs_size

  core_instance_type      = var.core_instance_type
  core_instance_ebs_size  = var.core_instance_ebs_size
  core_instance_count_max = var.core_instance_count_max
  core_instance_count_min = var.core_instance_count_min

  task_instance_type      = var.task_instance_type
  task_instance_ebs_size  = var.task_instance_ebs_size
  task_instance_count_max = var.task_instance_count_max
  task_instance_count_min = var.task_instance_count_min

  public_key = var.public_key

  bootstrap_action = var.bootstrap_action
  custom_ami_id    = var.custom_ami_id

  tags = var.tags
}
