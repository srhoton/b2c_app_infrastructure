resource "aws_route53_record" "cloudfront-a" {
  zone_id = "${data.aws_route53_zone.acm.zone_id}"
  name    = "${var.feature}.${var.route53_zone}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.b2c_frontend_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.b2c_frontend_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "gateway-a" {
  zone_id = "${data.aws_route53_zone.acm.zone_id}"
  name    = "api-${var.feature}.${var.route53_zone}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.gateway.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.gateway.regional_zone_id}"
    evaluate_target_health = true
  }
}