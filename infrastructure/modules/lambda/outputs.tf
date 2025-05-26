# outputs.tf
# Makes Lambda ARNs available to be used in the API Gateway module

output "upload_invoke_arn" {
  value = aws_lambda_function.upload.invoke_arn
}

output "download_invoke_arn" {
  value = aws_lambda_function.download.invoke_arn
}

