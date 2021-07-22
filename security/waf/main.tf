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
