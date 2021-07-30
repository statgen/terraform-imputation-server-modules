output "traffic_distribution" {
  description = "The ALB to direct production traffic to"
  value       = var.traffic_distribution
}

# Blue environment 
output "master_node_id_blue" {
  description = "EMR master node ID"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].master_node_id : ""
}

output "kms_key_arn_blue" {
  description = "The ARN of the KMS key used for EMR encryption"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].kms_key_arn : ""
}

output "kms_key_id_blue" {
  description = "The globally unique identifier for the key"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].kms_key_id : ""
}

output "kms_key_alias_blue" {
  description = "The ARN of the alias"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].kms_key_alias : ""
}

output "security_configuration_id_blue" {
  description = "The ID of the EMR Security Configuration"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].security_configuration_id : ""
}

output "security_configuration_name_blue" {
  description = "The name of the EMR Security Configuration"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].security_configuration_name : ""
}

output "security_configuration_blue" {
  description = "The JSON formatted Security Configuration"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].security_configuration : ""
}

output "emr_cluster_id_blue" {
  description = "The ID of the EMR Cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_cluster_id : ""
}

output "emr_cluster_name_blue" {
  description = "The name of the EMR Cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_cluster_name : ""
}

output "emr_cluster_release_label_blue" {
  description = "The release label for the EMR release"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_cluster_release_label : ""
}

output "emr_master_public_dns_blue" {
  description = "The public DNS name of the master EC2 instance"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_master_public_dns : ""
}

output "emr_log_uri_blue" {
  description = "The path to the Amazon S3 location where logs for this cluster are stored"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_log_uri : ""
}

output "emr_applications_blue" {
  description = "The applications installed on this cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_applications : []
}

output "emr_ec2_attributes_blue" {
  description = "Provides information about the EC2 instances in the cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_ec2_attributes : []
}

output "emr_bootstrap_action_blue" {
  description = "A list of bootstrap actions that will be run before Hadoop is started on the cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_bootstrap_action : []
}

output "emr_configurations_blue" {
  description = "The list of Configurations supplied to the EMR cluster"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_configurations : ""
}

output "emr_service_role_blue" {
  description = "The IAM role that will be assumed by the Amazon EMR service to access AWS resources"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_service_role : ""
}

output "emr_instance_group_id_blue" {
  description = "The EMR Instance ID"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_instance_group_id : ""
}

output "emr_instance_group_running_instance_count_blue" {
  description = "The number of instances currently running in this instance group"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_instance_group_running_instance_count : ""
}

output "emr_instance_group_name_blue" {
  description = "The name of the Instance Group"
  value       = var.enable_blue_application ? module.imputation_server_blue[0].emr_instance_group_name : ""
}

output "lb_dns_name_blue" {
  description = "The DNS name of the ALB"
  value       = var.enable_blue_application ? aws_lb.blue[0].dns_name : ""
}

output "lb_name_blue" {
  description = "The name of the ALB"
  value       = var.enable_blue_application ? aws_lb.blue[0].name : ""
}

# Green environment
output "master_node_id_green" {
  description = "EMR master node ID"
  value       = var.enable_green_application ? module.imputation_server_green[0].master_node_id : ""
}

output "kms_key_arn_green" {
  description = "The ARN of the KMS key used for EMR encryption"
  value       = var.enable_green_application ? module.imputation_server_green[0].kms_key_arn : ""
}

output "kms_key_id_green" {
  description = "The globally unique identifier for the key"
  value       = var.enable_green_application ? module.imputation_server_green[0].kms_key_id : ""
}

output "kms_key_alias_green" {
  description = "The ARN of the alias"
  value       = var.enable_green_application ? module.imputation_server_green[0].kms_key_alias : ""
}

output "security_configuration_id_green" {
  description = "The ID of the EMR Security Configuration"
  value       = var.enable_green_application ? module.imputation_server_green[0].security_configuration_id : ""
}

output "security_configuration_name_green" {
  description = "The name of the EMR Security Configuration"
  value       = var.enable_green_application ? module.imputation_server_green[0].security_configuration_name : ""
}

output "security_configuration_green" {
  description = "The JSON formatted Security Configuration"
  value       = var.enable_green_application ? module.imputation_server_green[0].security_configuration : ""
}

output "emr_cluster_id_green" {
  description = "The ID of the EMR Cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_cluster_id : ""
}

output "emr_cluster_name_green" {
  description = "The name of the EMR Cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_cluster_name : ""
}

output "emr_cluster_release_label_green" {
  description = "The release label for the EMR release"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_cluster_release_label : ""
}

output "emr_master_public_dns_green" {
  description = "The public DNS name of the master EC2 instance"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_master_public_dns : ""
}

output "emr_log_uri_green" {
  description = "The path to the Amazon S3 location where logs for this cluster are stored"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_log_uri : ""
}

output "emr_applications_green" {
  description = "The applications installed on this cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_applications : []
}

output "emr_ec2_attributes_green" {
  description = "Provides information about the EC2 instances in the cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_ec2_attributes : []
}

output "emr_bootstrap_action_green" {
  description = "A list of bootstrap actions that will be run before Hadoop is started on the cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_bootstrap_action : []
}

output "emr_configurations_green" {
  description = "The list of Configurations supplied to the EMR cluster"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_configurations : ""
}

output "emr_service_role_green" {
  description = "The IAM role that will be assumed by the Amazon EMR service to access AWS resources"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_service_role : ""
}

output "emr_instance_group_id_green" {
  description = "The EMR Instance ID"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_instance_group_id : ""
}

output "emr_instance_group_running_instance_count_green" {
  description = "The number of instances currently running in this instance group"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_instance_group_running_instance_count : ""
}

output "emr_instance_group_name_green" {
  description = "The name of the Instance Group"
  value       = var.enable_green_application ? module.imputation_server_green[0].emr_instance_group_name : ""
}

output "lb_dns_name_green" {
  description = "The DNS name of the ALB"
  value       = var.enable_green_application ? aws_lb.green[0].dns_name : ""
}

output "lb_name_green" {
  description = "The name of the ALB"
  value       = var.enable_green_application ? aws_lb.green[0].name : ""
}
