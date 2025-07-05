resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.prefix}-api"
  description = "Visitor counter API"
  tags        = var.common_tags
}

resource "aws_api_gateway_resource" "visitors" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "visitors"
}

resource "aws_api_gateway_method" "get_visitors" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.visitors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.visitors.id
  http_method             = aws_api_gateway_method.get_visitors.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor.invoke_arn
}

resource "aws_api_gateway_deployment" "deploy" {
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.api.id
  triggers = {
    redeployment = timestamp()
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

# Tell API Gateway that GET /visitors will return an Access-Control-Allow-Origin header
resource "aws_api_gateway_method_response" "get_visitors_cors" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method.get_visitors.http_method
  status_code = "200"

  response_parameters = {
    # Enable returning ACAO from the integration
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Map the header coming from your Lambda proxy response into that method response
resource "aws_api_gateway_integration_response" "get_visitors_cors" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_integration.lambda.http_method
  status_code = aws_api_gateway_method_response.get_visitors_cors.status_code

  response_parameters = {
    # Pull the ACAO header from the Lambda proxy output
    "method.response.header.Access-Control-Allow-Origin" = "integration.response.header.Access-Control-Allow-Origin"
  }
}

# OPTIONS /visitors
resource "aws_api_gateway_method" "options_visitors" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.visitors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# A MOCK integration that immediately returns 200
resource "aws_api_gateway_integration" "options_mock" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method.options_visitors.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

# Declare which headers & methods the preflight will return
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method.options_visitors.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# Tell the integration to synthesize those headers
resource "aws_api_gateway_integration_response" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.visitors.id
  http_method = aws_api_gateway_method.options_visitors.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
}