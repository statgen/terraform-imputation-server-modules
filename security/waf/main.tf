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
# CREATE WAF WEB ACL
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_waf_web_acl" "this" {
  name        = "ipBlackList"
  metric_name = "ipBlackListHits"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 10
    rule_id  = aws_waf_rule.this.id
    type     = "REGULAR"
  }

  tags = var.tags
}

resource "aws_waf_rule" "this" {
  name        = "ipBlackList"
  metric_name = "ipBlackListHits"

  predicates {
    data_id = aws_waf_ipset.this.id
    negated = false
    type    = "IPMatch"
  }

  tags = var.tags
}

resource "aws_waf_ipset" "this" {
  name = "ipBlackList"

  dynamic "ip_set_descriptors" {
    for_each = var.ipv4_address_blacklist
    content {
      type  = "IPV4"
      value = ip_set_descriptors.value
    }
  }
}
