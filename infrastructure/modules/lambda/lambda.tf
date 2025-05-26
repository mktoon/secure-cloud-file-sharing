# lambda.tf
# thsi file creates 2 lambda functions (upload_file, download file) with the correct
#  IAM roles and permisions to securely access the s3

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
    name    = "${var.project_name}-lambda_basic_policy"
    roles   = [aws_iam_role.lambda_role.name]
    policy_arn= "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_lambda_function" "upload" {
  function_name = "${var.project_name}-upload"
  handler       = "index.upload"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/functions/upload.zip"
}

resource "aws_lambda_function" "download" {
  function_name = "${var.project_name}-download"
  handler       = "index.download"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/functions/download.zip"
}
