locals {
  resrc_server_name = "book-service"
  scope_books       = "${local.resrc_server_name}/books"
  scope_categories  = "${local.resrc_server_name}/categories"
}

resource "aws_cognito_user_pool" "all_users" {
  name = "${local.prefix_short}-allusers"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  auto_verified_attributes = ["email"]
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  mfa_configuration = "OFF"
  schema {
    name                     = "email"
    attribute_data_type      = "String"
    required                 = true
    developer_only_attribute = false
    mutable                  = true
  }
  schema {
    name                     = "name"
    attribute_data_type      = "String"
    required                 = true
    developer_only_attribute = false
    mutable                  = true
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_uppercase                = false
    require_symbols                  = false
    require_numbers                  = false
    temporary_password_validity_days = 1
  }
  username_attributes = ["email"]
  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }
  username_configuration {
    case_sensitive = false
  }

  lifecycle {
    ignore_changes = [
      password_policy,
      schema
    ]
  }

  tags = {
    Name            = "${local.prefix_short}-allusers"
    CostCenter      = local.cost_center
    EnvironmentName = local.env_name
    EnvironmentType = local.configs["env_type"]
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${local.prefix_short}-users"
  user_pool_id = aws_cognito_user_pool.all_users.id
}

resource "aws_cognito_resource_server" "book-svc" {
  identifier = local.resrc_server_name
  name       = local.resrc_server_name

  scope {
    scope_name        = "books"
    scope_description = "Can manipulate books"
  }
  scope {
    scope_name        = "categories"
    scope_description = "Can manipulate categories"
  }

  user_pool_id = aws_cognito_user_pool.all_users.id
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "ClientApp"
  allowed_oauth_scopes                 = ["openid", "email", local.scope_books, local.scope_categories]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["https://example.com"]
  explicit_auth_flows                  = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  generate_secret                      = false
  refresh_token_validity               = 3
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  user_pool_id = aws_cognito_user_pool.all_users.id
}
