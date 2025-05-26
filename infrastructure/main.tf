# Root Main Terraform Configuration
# - Connects modules for Cognito, S3, Lambda, API Gateway
# - Passes outputs and shared variables

provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

# Cognito Authentication
module "cognito" {
  source = "./modules/cognito"

  project_name                  = var.project_name
  callback_urls = ["http://localhost:3000"]
  logout_urls   = ["http://localhost:3000/logout"]
}

# S3 Bucket
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  bucket_name = "secure-files-${random_id.project_suffix.hex}"
}

resource "random_id" "project_suffix" {
  byte_length = 4
}


# Lambda Functions
module "lambda" {
  source = "./modules/lambda"
  project_name = var.project_name
  bucket_name  = module.s3.bucket_name
}

# API Gateway
module "apigateway" {
  source = "./modules/apigateway"

  project_name                  = var.project_name
  region                        = var.region
  upload_lambda_invoke_arn      = module.lambda.upload_invoke_arn
  download_lambda_invoke_arn    = module.lambda.download_invoke_arn
  cognito_user_pool_arn         = module.cognito.user_pool_arn
}
