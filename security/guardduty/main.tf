# ---------------------------------------------------------------------------------------------------------------------
# ENABLE GUARDDUTY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_guardduty_detector" "this" {
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency
}
