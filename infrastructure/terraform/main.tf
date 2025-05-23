# main.tf

# Define the AWS provider and region
provider "aws" {
  region = "us-west-2"
}

# Create a secure and versioned S3 bucket with encryption
resource "aws_s3_bucket" "secure_files" {
  bucket = "micah-secure-files321"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Project = "SecureFileSharing"
  }
}

# IAM role that allows Lambda to assume execution permissions
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy to Lambda role for basic execution
resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Define the Lambda function for file uploads
resource "aws_lambda_function" "upload_file" {
  filename         = "../lambda/upload_file.zip"
  function_name    = "upload_file"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "upload_file.handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("../lambda/upload_file.zip")
  timeout          = 10

  environment {
    variables = {
      BUCKET = aws_s3_bucket.secure_files.bucket
    }
  }
}

# Define a REST API shell for future Lambda integration
resource "aws_api_gateway_rest_api" "file_api" {
  name = "FileSharingAPI"
}

# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/upload_file"
  retention_in_days = 7
}

# Output the S3 bucket name
output "bucket_name" {
  value = aws_s3_bucket.secure_files.bucket
}
