# ----------------------------------------------------------------------------------------------------------------------
# CREATE IMPUTATION CLOUDFRONT DISTRIBUTION
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

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = true

      headers = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

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

  web_acl_id = var.web_acl_id

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

  source_code_hash = filebase64sha256("functions/function.zip")

  description = "Lambda Edge function to set proper security headers"

  runtime = "nodejs14.x"

  tags = var.tags
}
