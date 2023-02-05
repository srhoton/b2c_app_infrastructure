data "aws_route53_zone" "acm" {
  name = var.route53_zone
  private_zone = false
}

resource "aws_acm_certificate" "cloudfront_certificate" {
  domain_name = "${var.feature}.${var.route53_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "acm_record" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.acm.zone_id
}

resource "aws_acm_certificate_validation" "cloudfront_certificate_validation" {
  certificate_arn = aws_acm_certificate.cloudfront_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]
  
}

resource "aws_acm_certificate" "gateway_certificate" {
  domain_name = "api-${var.feature}.${var.route53_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "gateway_record" {
  for_each = {
    for dvo in aws_acm_certificate.gateway_certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.acm.zone_id
}

resource "aws_acm_certificate_validation" "gateway_certificate_validation" {
  certificate_arn = aws_acm_certificate.gateway_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.gateway_record : record.fqdn]
  
}