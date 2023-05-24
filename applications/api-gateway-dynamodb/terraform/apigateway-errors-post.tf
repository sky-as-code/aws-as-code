resource "aws_api_gateway_method" "post_error" {
  rest_api_id          = aws_api_gateway_rest_api.restapi.id
  resource_id          = aws_api_gateway_resource.errors.id
  http_method          = "POST"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.cognito.id
  authorization_scopes = [local.scope_books]
}

resource "aws_api_gateway_integration" "post_error" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.errors.id
  http_method = aws_api_gateway_method.post_error.http_method

  type                    = "AWS"
  credentials             = aws_iam_role.apigateway_role.arn
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${local.aws_region}:dynamodb:action/UpdateItem"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${aws_dynamodb_table.ddb_books.name}",
  Mal-formed JSON to throw error
}
EOF
  }
}

resource "aws_api_gateway_method_response" "errors_post_400" {
  depends_on = [
    aws_api_gateway_integration.post_error,
    aws_api_gateway_method.post_error,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.errors.id
  http_method = aws_api_gateway_method.post_error.http_method
  status_code = "400"
}

resource "aws_api_gateway_integration_response" "errors_post_400" {
  depends_on = [
    aws_api_gateway_integration.post_error,
    aws_api_gateway_method.post_error,
    aws_api_gateway_method_response.errors_post_400,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.errors.id
  http_method = aws_api_gateway_method.post_error.http_method
  status_code = aws_api_gateway_method_response.errors_post_400.status_code

  # See more about Velocity Language: https://velocity.apache.org/engine/devel/vtl-reference.html
  # Mapping template variables: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
  response_templates = {
    "application/json" = <<EOF
{
  "message": "An error occured"
}
EOF
  }
}
