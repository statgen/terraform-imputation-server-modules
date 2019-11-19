output "flow_log_ids" {
  description = "A list of Flow Log IDs"
  value = [
    for aws_flow_log in aws_flow_log.this :
    aws_flow_log.id
  ]
}
