# outputs.tf
# this file defines outputs that are useful for debugging and accessing deployed infra/resources

output "api_gateway_url" {
    description     = "base URL for deployed API Gateway"
    value           = module.apigateway.api_url
}

output "cognito_user_pool" {
    description     = "The ID of the cognito user pool"
    value           = module.cognito.user_pool_id
}

output "s3_bucket_name" {
    description     = "Name of the secure file bucket"
    value           = module.s3.bucket_name
}