output "prod_route53_zone_id" {
  description = "The Hosted Zone ID"
  value       = aws_route53_zone.prod.zone_id
}

output "prod_route_53_zone_name_servers" {
  description = "A list of name servers in associated delegation set"
  value       = aws_route53_zone.prod.name_servers
}

output "dev_route53_zone_id" {
  description = "The Hosted Zone ID"
  value       = aws_route53_zone.dev.zone_id
}

output "dev_route_53_zone_name_servers" {
  description = "A list of name servers in associated delegation set"
  value       = aws_route53_zone.dev.name_servers
}

output "mgmt_route53_zone_id" {
  description = "The Hosted Zone ID"
  value       = aws_route53_zone.mgmt.zone_id
}

output "mgmt_route_53_zone_name_servers" {
  description = "A list of name servers in associated delegation set"
  value       = aws_route53_zone.mgmt.name_servers
}

output "topmed_subdomain_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.topmed_subdomain.name
}

output "topmed_subdomain_record_fqdn" {
  description = "The FQDN built using the zone domain and name"
  value       = aws_route53_record.topmed_subdomain.fqdn
}

output "dev_subdomain_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.dev_subdomain.name
}

output "dev_subdomain_record_fqdn" {
  description = "The FQDN built using the zone domain and name"
  value       = aws_route53_record.dev_subdomain.fqdn
}

output "mgmt_subdomain_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.mgmt_subdomain.name
}

output "mgmt_subdomain_record_fqdn" {
  description = "The FQDN built using the zone domain and name"
  value       = aws_route53_record.mgmt_subdomain.fqdn
}
