variable "region" {
  description = "AWS region"
  type        = string
} 

variable "upload_lambda_invoke_arn" {
  description = "Invoke ARN for the upload Lambda function"
  type        = string
}

variable "download_lambda_invoke_arn" {
  description = "Invoke ARN for the download Lambda function"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  type        = string
}

variable "project_name" {
  type        = string
  description = "Project name to prefix resources"
}

