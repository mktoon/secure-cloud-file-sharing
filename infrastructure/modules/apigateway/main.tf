########################################
# API Gateway Module
# - Creates a REST API
# - Integrates with Lambda (upload & download)
# - Secures endpoints using Cognito Authorizer


resource "aws_api_gateway_rest_api" "secure_file_api" {
  name        = "secure-file-sharing-api"
  description = "API Gateway for secure file sharing using Lambda and Cognito"
}

resource "aws_api_gateway_resource" "upload" {
  rest_api_id = aws_api_gateway_rest_api.secure_file_api.id
  parent_id   = aws_api_gateway_rest_api.secure_file_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_resource" "download" {
  rest_api_id = aws_api_gateway_rest_api.secure_file_api.id
  parent_id   = aws_api_gateway_rest_api.secure_file_api.root_resource_id
  path_part   = "download"
}

# Cognito Authorizer
resource "aws_api_gateway_authorizer" "cognito_auth" {
  name          = "CognitoAuth"
  rest_api_id   = aws_api_gateway_rest_api.secure_file_api.id
  identity_source = "method.request.header.Authorization"
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
}

# Upload POST Method
resource "aws_api_gateway_method" "upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.secure_file_api.id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

# Upload Integration
resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id = aws_api_gateway_rest_api.secure_file_api.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.upload_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.upload_lambda_invoke_arn
}

# Download GET Method
resource "aws_api_gateway_method" "download_get" {
  rest_api_id   = aws_api_gateway_rest_api.secure_file_api.id
  resource_id   = aws_api_gateway_resource.download.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

# Download Integration
resource "aws_api_gateway_integration" "download_integration" {
  rest_api_id = aws_api_gateway_rest_api.secure_file_api.id
  resource_id = aws_api_gateway_resource.download.id
  http_method = aws_api_gateway_method.download_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.download_lambda_invoke_arn
}

# Deployment & Stage
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.upload_integration,
    aws_api_gateway_integration.download_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.secure_file_api.id
  
}


resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.secure_file_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}
