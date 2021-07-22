module "cloudtrail_api_alarms" {
  source         = "github.com/jdpleiness/terraform-aws-cloudtrail-cloudwatch-alarms.git"
  region         = var.aws_region
  log_group_name = var.log_group_name
}
