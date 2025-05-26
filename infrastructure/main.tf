# main.tf
# this file brings all the modules together, S3, lambda, gateway,cognito and API gateway

module "s3" {
    source  = "./modules/s3"
    project_name = var.project_name
}

module "lambda" {
    source          = "./modules/lambda"
    project_name    = var.project_name
    bucket_name     = module.s3.bucket_name
}

module "cognito: {
    source = "./modules/cognito"
    project_name = var.project_name
}

module "apigateway" {
  source            = "./modules/apigateway"
  project_name      = var.project_name
  lambda_upload_arn = module.lambda.upload_function_arn
  lambda_download_arn = module.lambda.download_function_arn
  user_pool_id      = module.cognito.user_pool_id
}