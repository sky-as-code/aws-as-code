resource "aws_api_gateway_rest_api" "restapi" {
  name = "${local.prefix}-restapi"

  tags = merge(local.tags, {
    Name = "${local.prefix}-restapi"
  })
}

resource "aws_api_gateway_authorizer" "cognito" {
  name            = "${local.prefix}-cognito-authorizer"
  identity_source = "method.request.header.authorization"
  provider_arns   = [aws_cognito_user_pool.all_users.arn]
  type            = "COGNITO_USER_POOLS"

  rest_api_id = aws_api_gateway_rest_api.restapi.id

}

resource "aws_api_gateway_deployment" "restapi" {
  depends_on = [
    aws_api_gateway_integration.post_book,
    aws_api_gateway_integration.get_book,
    aws_api_gateway_integration.get_bookId
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      # Must add new resources here to avoid error 
      aws_api_gateway_resource.books.id,
      aws_api_gateway_resource.bookId.id,

      # Must add new methods here to avoid error 
      aws_api_gateway_method.post_book.id,
      aws_api_gateway_method.get_book.id,
      aws_api_gateway_method.get_bookId.id,
      aws_api_gateway_integration.post_book.id,
      aws_api_gateway_integration.get_book.id,
      aws_api_gateway_integration.get_bookId.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "reststage" {
  deployment_id = aws_api_gateway_deployment.restapi.id
  rest_api_id   = aws_api_gateway_rest_api.restapi.id
  stage_name    = local.env_name

  variables = {
    "deployedAt" = timestamp()
  }
}

resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  stage_name  = aws_api_gateway_stage.reststage.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled    = false
    data_trace_enabled = false
    logging_level      = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_api_gateway_resource" "books" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_rest_api.restapi.root_resource_id
  path_part   = "books"
}

resource "aws_api_gateway_resource" "bookId" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_resource.books.id
  path_part   = "{bookId}"
}
