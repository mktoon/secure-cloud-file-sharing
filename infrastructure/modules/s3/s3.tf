# s3.tf
# This file creates an S3 bucket configured with encryption, versioning, and appropriate access policies.


# S3 Bucket with Versioning and Server-Side Encryption (AES256)
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "${var.project_name}-secure-bucket"

  force_destroy = true  # Optional: Useful during testing to delete non-empty buckets

  tags = {
    Name        = "${var.project_name}-secure-bucket"
    Environment = "Production"
  }
}


# Enable Versioning on S3
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Enable AES256 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Optional: Public Access Block (Extra Security)
resource "aws_s3_bucket_public_access_block" "secure_bucket_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket Policy to Allow Lambda Access to Upload/Download
resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowLambdaAccess"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.secure_bucket.arn}/*"
      }
    ]
  })
}
