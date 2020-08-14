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
  required_version = ">= 0.13"
}

data "aws_route53_zone" "tld" {
  name = "imputationserver.org"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 PROD SUBDOMAIN ZONE AND RECORDS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_zone" "prod" {
  name    = "topmed.imputationserver.org"
  comment = "Subdomain for production imputation server"

  tags = var.tags
}

resource "aws_route53_record" "topmed_subdomain" {
  zone_id = data.aws_route53_zone.tld.zone_id
  name    = aws_route53_zone.prod.name
  type    = "NS"
  ttl     = 172800
  records = aws_route53_zone.prod.name_servers
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 DEV SUBDOMAIN ZONE AND RECORDS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_zone" "dev" {
  name    = "dev.imputationserver.org"
  comment = "Subdomain for dev environment"

  tags = var.tags
}

resource "aws_route53_record" "dev_subdomain" {
  zone_id = data.aws_route53_zone.tld.zone_id
  name    = aws_route53_zone.dev.name
  type    = "NS"
  ttl     = 172800
  records = aws_route53_zone.dev.name_servers
}

resource "aws_route53_record" "cert_validation" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "_1b5dcd00b78c2c8f1703c698f602f120.dev.imputationserver.org."
  type    = "CNAME"
  ttl     = 300
  records = ["_01cf07d754a482e4ccf7315de1e494f4.olprtlswtu.acm-validations.aws."]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE53 MGMT SUBDOMAIN ZONE AND RECORDS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_zone" "mgmt" {
  name    = "mgmt.imputationserver.org"
  comment = "Subdomain for mgmt environment"

  tags = var.tags
}

resource "aws_route53_record" "mgmt_subdomain" {
  zone_id = data.aws_route53_zone.tld.zone_id
  name    = aws_route53_zone.mgmt.name
  type    = "NS"
  ttl     = 172800
  records = aws_route53_zone.mgmt.name_servers
}
