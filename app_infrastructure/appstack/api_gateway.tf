resource "aws_apigatewayv2_api" "b2c_api" {
  name = "b2c-api-${var.feature}"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "b2c_root_integration" {
  api_id = aws_apigatewayv2_api.b2c_api.id
  description = "Root integration for b2c api-${var.feature}"
  integration_type = "HTTP_PROXY"
  integration_uri = "http://${aws_lb.b2c_frontend_lb.dns_name}:80"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_integration" "b2c_contacts_integration" {
  api_id = aws_apigatewayv2_api.b2c_api.id
  description = "Contacts integration for b2c api-${var.feature}"
  integration_type = "HTTP_PROXY"
  integration_uri = "http://${aws_lb.b2c_frontend_lb.dns_name}:80/contacts"
  integration_method = "GET"
}

resource "aws_apigatewayv2_route" "b2c_root_route" {
  api_id = aws_apigatewayv2_api.b2c_api.id
  route_key = "ANY /"
  target = "integrations/${aws_apigatewayv2_integration.b2c_root_integration.id}"
}

resource "aws_apigatewayv2_route" "b2c_contacts_route" {
  api_id = aws_apigatewayv2_api.b2c_api.id
  route_key = "GET /contacts"
  target = "integrations/${aws_apigatewayv2_integration.b2c_contacts_integration.id}"
}

resource "aws_apigatewayv2_stage" "b2c_default" {
  api_id = aws_apigatewayv2_api.b2c_api.id
  name = "$default" 
  auto_deploy = true
  description = "b2c api default deployment stage-${var.feature}"
}

resource "aws_api_gateway_domain_name" "gateway" {
  domain_name              = "api-${var.feature}.${var.route53_zone}"
  regional_certificate_arn = aws_acm_certificate_validation.gateway_certificate_validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_apigatewayv2_api_mapping" "root_mapping" {
  api_id      = aws_apigatewayv2_api.b2c_api.id
  stage  = "$default"
  domain_name = aws_api_gateway_domain_name.gateway.domain_name
}