# ----------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION SERVER EMR CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

locals {
  ec2_subnet_blue  = element(var.ec2_subnet_blue, 0)
  ec2_subnet_green = element(var.ec2_subnet_green, 0)
}

module "imputation_server_blue" {
  source = "github.com/jdpleiness/terraform-aws-imputation-server.git//modules/imputation-server"

  count = var.enable_blue_application ? 1 : 0

  name_prefix = "${var.name_prefix}-blue"

  vpc_id                            = var.vpc_id_blue
  ec2_subnet                        = local.ec2_subnet_blue
  emr_managed_master_security_group = var.emr_managed_master_security_group_blue
  emr_managed_slave_security_group  = var.emr_managed_slave_security_group_blue
  service_access_security_group     = var.service_access_security_group_blue

  ec2_autoscaling_role_name = var.ec2_autoscaling_role_name_blue
  ec2_role_arn              = var.ec2_role_arn_blue
  ec2_instance_profile_name = var.ec2_instance_profile_name_blue
  emr_role_arn              = var.emr_role_arn_blue
  emr_role_name             = var.emr_role_name_blue
  emr_release_label         = var.emr_release_label_blue
  log_uri                   = var.log_uri_blue

  master_instance_type     = var.master_instance_type_blue
  master_instance_ebs_size = var.master_instance_ebs_size_blue

  core_instance_type      = var.core_instance_type_blue
  core_instance_ebs_size  = var.core_instance_ebs_size_blue
  core_instance_count_max = var.core_instance_count_max_blue
  core_instance_count_min = var.core_instance_count_min_blue

  task_instance_type      = var.task_instance_type_blue
  task_instance_ebs_size  = var.task_instance_ebs_size_blue
  task_instance_count_max = var.task_instance_count_max_blue
  task_instance_count_min = var.task_instance_count_min_blue

  public_key = var.public_key_blue

  bootstrap_action = var.bootstrap_action_blue
  custom_ami_id    = var.custom_ami_id_blue

  tags = var.tags
}


module "imputation_server_green" {
  source = "github.com/jdpleiness/terraform-aws-imputation-server.git//modules/imputation-server"

  count = var.enable_green_application ? 1 : 0

  name_prefix = "${var.name_prefix}-green"

  vpc_id                            = var.vpc_id_green
  ec2_subnet                        = local.ec2_subnet_green
  emr_managed_master_security_group = var.emr_managed_master_security_group_green
  emr_managed_slave_security_group  = var.emr_managed_slave_security_group_green
  service_access_security_group     = var.service_access_security_group_green

  ec2_autoscaling_role_name = var.ec2_autoscaling_role_name_green
  ec2_role_arn              = var.ec2_role_arn_green
  ec2_instance_profile_name = var.ec2_instance_profile_name_green
  emr_role_arn              = var.emr_role_arn_green
  emr_role_name             = var.emr_role_name_green
  emr_release_label         = var.emr_release_label_green
  log_uri                   = var.log_uri_green

  master_instance_type     = var.master_instance_type_green
  master_instance_ebs_size = var.master_instance_ebs_size_green

  core_instance_type      = var.core_instance_type_green
  core_instance_ebs_size  = var.core_instance_ebs_size_green
  core_instance_count_max = var.core_instance_count_max_green
  core_instance_count_min = var.core_instance_count_min_green

  task_instance_type      = var.task_instance_type_green
  task_instance_ebs_size  = var.task_instance_ebs_size_green
  task_instance_count_max = var.task_instance_count_max_green
  task_instance_count_min = var.task_instance_count_min_green

  public_key = var.public_key_green

  bootstrap_action = var.bootstrap_action_green
  custom_ami_id    = var.custom_ami_id_green

  tags = var.tags
}

data "aws_acm_certificate" "this" {
  domain = var.domain
}

resource "aws_lb" "blue" {
  count = var.enable_blue_application ? 1 : 0

  name = "${var.name_prefix}-lb-blue"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group]
  subnets            = var.lb_subnets

  tags = var.tags
}

resource "aws_lb" "green" {
  count = var.enable_green_application ? 1 : 0

  name = "${var.name_prefix}-lb-green"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group]
  subnets            = var.lb_subnets

  tags = var.tags
}

resource "aws_lb_listener" "blue" {
  count = var.enable_blue_application ? 1 : 0

  load_balancer_arn = aws_lb.blue[0].id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.this.id
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue[0].arn
  }
}

resource "aws_lb_listener" "green" {
  count = var.enable_green_application ? 1 : 0

  load_balancer_arn = aws_lb.green[0].id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.this.id
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green[0].arn
  }
}

resource "aws_lb_target_group" "blue" {
  count = var.enable_blue_application ? 1 : 0

  name     = "${var.name_prefix}-blue"
  port     = var.backend_port_blue
  protocol = "HTTP"
  vpc_id   = var.vpc_id_blue

  health_check {
    enabled             = true
    path                = "/index.html"
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "blue" {
  count = var.enable_blue_application ? 1 : 0

  target_group_arn = aws_lb_target_group.blue[0].id
  target_id        = module.imputation_server_blue[0].master_node_id
  port             = var.backend_port_blue
}

resource "aws_lb_target_group" "green" {
  count = var.enable_green_application ? 1 : 0

  name     = "${var.name_prefix}-green"
  port     = var.backend_port_green
  protocol = "HTTP"
  vpc_id   = var.vpc_id_green

  health_check {
    enabled             = true
    path                = "/index.html"
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "green" {
  count = var.enable_green_application ? 1 : 0

  target_group_arn = aws_lb_target_group.green[0].id
  target_id        = module.imputation_server_green[0].master_node_id
  port             = var.backend_port_green
}
