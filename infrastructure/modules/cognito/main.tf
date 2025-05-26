# Cognito Module
# - Creates a Cognito User Pool
# - Sets up an App Client for authentication
# - (Optional) Creates a User Group


resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "${var.project_name}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret           = false
  explicit_auth_flows       = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["http://localhost:3000"]
  logout_urls   = ["http://localhost:3000/logout"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
}

# Optional: Group for admin or elevated permissions
resource "aws_cognito_user_group" "admin_group" {
  name        = "admins"
  user_pool_id = aws_cognito_user_pool.main.id
  description = "Admin users with elevated privileges"
  precedence  = 1
}
