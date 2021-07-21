# ---------------------------------------------------------------------------------------------------------------------
# CREATE AWS CONFIG AGGREGATOR
# ---------------------------------------------------------------------------------------------------------------------

data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_config_configuration_aggregator" "this" {
  name = "default"

  account_aggregation_source {
    account_ids = [data.aws_caller_identity.current.account_id]
    all_regions = true
  }

  tags = var.tags
}