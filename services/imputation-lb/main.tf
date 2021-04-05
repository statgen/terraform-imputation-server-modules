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
# CREATE APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

data "aws_acm_certificate" "this" {
  domain = var.domain
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.12.0"

  name = "${var.name_prefix}-lb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  security_groups = [var.lb_security_group]
  subnets         = var.lb_subnets

  target_groups = [
    {
      name             = "${var.name_prefix}-tg-2"
      backend_port     = var.backend_port
      backend_protocol = "HTTP"
      protocol_version = "HTTP1"
      target_type      = "instance"
      health_check = {
        enabled             = true
        path                = "/index.html"
        port                = "traffic-port"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
      stickiness = {
        type    = "lb_cookie"
        enabled = false
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.this.arn
      ssl_policy         = var.ssl_policy
      target_group_index = 0
    }
  ]

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "imputation_tg_target" {
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = var.master_node_id
  port             = var.backend_port
}
