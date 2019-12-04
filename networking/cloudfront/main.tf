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
  required_version = "= 0.12.17"
}

data "aws_acm_certificate" "this" {
  domain = var.sub_domain
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "functions/index.js"
  output_path = "functions/function.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDFRONT DISTRIBUTION
# ----------------------------------------------------------------------------------------------------------------------

locals {
  origin_id = "${var.name_prefix}-cloudfront-origin"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.lb_dns_name
    origin_id   = local.origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = var.log_bucket
    prefix          = "cloudfront"
  }

  aliases = ["topmed.${var.sub_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      headers = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = aws_lambda_function.this.qualified_arn
      include_body = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.this.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDA@EDGE FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "this" {
  filename      = "functions/function.zip"
  function_name = "${var.name_prefix}-sec-headers"
  role          = var.lambda_edge_role_arn
  handler       = "index.handler"
  publish       = true

  source_code_hash = "${filebase64sha256("functions/function.zip")}"

  description = "Lambda Edge function to set proper security headers"

  runtime = "nodejs8.10"

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 RECORD FOR CLOUDFRONT
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "a" {
  depends_on = [aws_cloudfront_distribution.this]
  zone_id    = var.route53_zone_id
  name       = "topmed.${var.sub_domain}"

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
