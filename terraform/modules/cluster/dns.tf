resource "aws_route53_record" "this" {
  count = var.enable_ssl ? 1 : 0
  
  zone_id = var.zone_id
  name = var.domain_name
  type = "A"

  alias {
    name = aws_alb.this.dns_name
    zone_id = aws_alb.this.zone_id
    evaluate_target_health = true
  }
}