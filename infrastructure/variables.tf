# Variables.tf
# declares all input variables that can be reused across modules
# variables provides flexibility and prevents hardcoding values

variables "aws_region" {
    description = "AWS region to deploy resources in"
    type        = string
    default     = "us-west-2"

}

variable "project_name" {
    description     = "A short name to prefix all the resource names"
    type            = string
    default         = securecloud
}