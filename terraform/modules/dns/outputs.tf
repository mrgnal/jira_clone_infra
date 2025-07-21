output "name_servers" {
  value       = aws_route53_zone.this.name_servers
}

output "certificate_arn" {
  value       = aws_acm_certificate.this.arn
}

output "zone_id" {
  value = aws_route53_zone.this.id
}