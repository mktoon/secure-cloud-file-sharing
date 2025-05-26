// variables.tf
// Defines input variables needed for Lambda deployment

variable "project_name" {
  description = "Name used as a prefix for all Lambda-related resources"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket Lambda functions will access"
  type        = string
}
