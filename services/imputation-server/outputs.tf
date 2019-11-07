output "master_node_id" {
  description = "EMR master node ID"
  value       = module.imputation-server.master_node_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for EMR encryption"
  value       = module.imputation-server.kms_key_arn
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = module.imputation-server.kms_key_id
}

output "kms_key_alias" {
  description = "The ARN of the alias"
  value       = module.imputation-server.kms_key_alias
}

output "security_configuration_id" {
  description = "The ID of the EMR Security Configuration"
  value       = module.imputation-server.security_configuration_id
}

output "security_configuration_name" {
  description = "The name of the EMR Security Configuration"
  value       = module.imputation-server.security_configuration_name
}

output "security_configuration" {
  description = "The JSON formatted Security Configuration"
  value       = module.imputation-server.security_configuration
}

output "emr_cluster_id" {
  description = "The ID of the EMR Cluster"
  value       = module.imputation-server.emr_cluster_id
}

output "emr_cluster_name" {
  description = "The name of the EMR Cluster"
  value       = module.imputation-server.emr_cluster_name
}

output "emr_cluster_release_label" {
  description = "The release label for the EMR release"
  value       = module.imputation-server.emr_cluster_release_label
}

output "emr_master_public_dns" {
  description = "The public DNS name of the master EC2 instance"
  value       = module.imputation-server.emr_master_public_dns
}

output "emr_log_uri" {
  description = "The path to the Amazon S3 location where logs for this cluster are stored"
  value       = module.imputation-server.emr_log_uri
}

output "emr_applications" {
  description = "The applications installed on this cluster"
  value       = module.imputation-server.emr_applications
}

output "emr_ec2_attributes" {
  description = "Provides information about the EC2 instances in the cluster"
  value       = module.imputation-server.emr_ec2_attributes
}

output "emr_bootstrap_action" {
  description = "A list of bootstrap actions that will be run before Hadoop is started on the cluster"
  value       = module.imputation-server.emr_bootstrap_action
}

output "emr_configurations" {
  description = "The list of Configurations supplied to the EMR cluster"
  value       = module.imputation-server.emr_configurations
}

output "emr_service_role" {
  description = "The IAM role that will be assumed by the Amazon EMR service to access AWS resources"
  value       = module.imputation-server.emr_service_role
}

output "emr_instance_group_id" {
  description = "The EMR Instance ID"
  value       = module.imputation-server.emr_instance_group_id
}

output "emr_instance_group_running_instance_count" {
  description = "The number of instances currently running in this instance group"
  value       = module.imputation-server.emr_instance_group_running_instance_count
}

output "emr_instance_group_name" {
  description = "The name of the Instance Group"
  value       = module.imputation-server.emr_instance_group_name
}
