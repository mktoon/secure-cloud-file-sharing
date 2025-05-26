# outputs.tf
# This file defines outputs for the S3 module, making it accessible to other modules.

output "bucket_name" {
  description = "The name of the S3 bucket created"
  value       = aws_s3_bucket.secure_bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket created"
  value       = aws_s3_bucket.secure_bucket.arn
}
