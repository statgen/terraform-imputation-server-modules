variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
