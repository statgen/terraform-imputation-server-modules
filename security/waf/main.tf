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
  required_version = "= 0.12.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE WAF WEB ACL
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_waf_web_acl" "this" {
  depends_on  = [aws_waf_ipset.this, aws_waf_rule.this]
  name        = "restrictDevAccessUmich"
  metric_name = "restrictDevAccessUmich"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "COUNT"
    }

    priority = 10
    rule_id  = aws_waf_rule.this.id
    type     = "REGULAR"
  }

  tags = var.tags
}

resource "aws_waf_rule" "this" {
  depends_on  = [aws_waf_ipset.this]
  name        = "restrictDevAccessUmich"
  metric_name = "restrictDevAccessUmich"

  # Does not originate from these IP cidrs
  predicates {
    data_id = aws_waf_ipset.this.id
    negated = true
    type    = "IPMatch"
  }

  # && Does match the Regex outlined
  predicates {
    data_id = aws_waf_regex_match_set.this.id
    negated = false
    type    = "RegexMatch"
  }

  tags = var.tags
}

resource "aws_waf_ipset" "this" {
  name = "restrictDevAccessUmich"

  ip_set_descriptors {
    type  = "IPV4"
    value = "141.211.8.0/22"
  }

  ip_set_descriptors {
    type  = "IPV4"
    value = "141.211.29.64/26"
  }

  ip_set_descriptors {
    type  = "IPV4"
    value = "141.213.128.0/17"
  }
}

resource "aws_waf_regex_pattern_set" "this" {
  name                  = "restrictDevAccessUmich"
  regex_pattern_strings = ["[a-z0-9]+[.]dev[.]imputationserver[.]org"]
}

resource "aws_waf_regex_match_set" "this" {
  name = "restrictDevAccessUmich"
  regex_match_tuple {
    field_to_match {
      type = "URI"
    }

    regex_pattern_set_id = aws_waf_regex_pattern_set.this.id
    text_transformation  = "LOWERCASE"
  }
}
