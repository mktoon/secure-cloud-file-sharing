variable "project_name" {
  description = "Project prefix for resource names"
  type        = string
}

variable "callback_urls" {
  description = "Callback URLs for Cognito hosted UI"
  type        = list(string)
  default     = ["http://localhost:3000"]
}

variable "logout_urls" {
  description = "Logout URLs for Cognito hosted UI"
  type        = list(string)
  default     = ["http://localhost:3000/logout"]
}
