resource "aws_cloudfront_distribution" "b2c_frontend_distribution" {
  aliases = [ "${var.feature}.${var.route53_zone}" ]
  origin {
    domain_name = aws_lb.b2c_frontend_lb.dns_name
    origin_id = "b2c_frontend-${var.feature}"
    custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols = ["TLSv1.2"]
    }
  }
  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.cloudfront_certificate.arn
    ssl_support_method = "sni-only"
  }
  enabled = true
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "b2c_frontend-${var.feature}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }
}
output "cloudfront_dns_name" {
  value = aws_cloudfront_distribution.b2c_frontend_distribution.domain_name
  description = "The Cloudfront frontend DNS Name"
}
