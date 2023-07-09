resource "aws_api_gateway_rest_api" "restapi" {
  name = "${local.prefix}-restapi"

  tags = merge(local.tags, {
    Name = "${local.prefix}-restapi"
  })
}

resource "aws_api_gateway_deployment" "restapi" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      # Must add new resources here to avoid error 
      aws_api_gateway_resource.books.id,
      aws_api_gateway_resource.bookId.id,
      aws_api_gateway_resource.errors.id,

      # Must add new methods here to avoid error 
      aws_api_gateway_method.post_book.id,
      aws_api_gateway_method.get_book.id,
      aws_api_gateway_method.get_bookId.id,
      aws_api_gateway_method.delete_bookId.id,
      aws_api_gateway_method.post_error.id,
      aws_api_gateway_integration.post_book.id,
      aws_api_gateway_integration.get_book.id,
      aws_api_gateway_integration.get_bookId.id,
      aws_api_gateway_integration.delete_bookId.id,
      aws_api_gateway_integration.post_error.id,
      aws_api_gateway_integration_response.books_post_success,
      aws_api_gateway_integration_response.books_get_success,
      aws_api_gateway_integration_response.bookId_get_success,
      aws_api_gateway_integration_response.bookId_delete_success,
      aws_api_gateway_integration_response.errors_post_400,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "reststage" {
  depends_on = [
    aws_cloudwatch_log_group.api_logs,
  ]

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
    data_trace_enabled = true
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

resource "aws_api_gateway_resource" "errors" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_resource.books.id
  path_part   = "errors"
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.restapi.id}/${local.env_name}"
  retention_in_days = 1
  tags = merge(local.tags, {
    Name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.restapi.id}/${local.env_name}"
  })
}
