# variables.tf
# defines input variables required b the s3 module

variable "project_name" {
    description = "Prefix for naming the s3 bucket"
    type        = string
}

variable "bucket_name" {
  type        = string
  description = "Custom name for the S3 bucket"
}
