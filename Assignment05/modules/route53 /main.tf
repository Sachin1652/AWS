################################
# EXISTING HOSTED ZONE (DATA)
################################
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

################################
# ROOT DOMAIN → ALB
################################
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

################################
# SUBDOMAIN (www/api/jenkins) → ALB
################################
resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
