variable "ipv4_address_blacklist" {
  description = "A list of IPV4 address to block via WAF"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply to module resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}
