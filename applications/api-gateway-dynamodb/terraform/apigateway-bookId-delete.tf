resource "aws_api_gateway_method" "delete_bookId" {
  rest_api_id          = aws_api_gateway_rest_api.restapi.id
  resource_id          = aws_api_gateway_resource.bookId.id
  http_method          = "DELETE"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.cognito.id
  authorization_scopes = [local.scope_books]
}

resource "aws_api_gateway_integration" "delete_bookId" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.bookId.id
  http_method = aws_api_gateway_method.delete_bookId.http_method

  type                    = "AWS"
  credentials             = aws_iam_role.apigateway_role.arn
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${local.aws_region}:dynamodb:action/DeleteItem"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${aws_dynamodb_table.ddb_books.name}",
  "Key": {
    "Id": {
      "S": "$input.params('bookId')"
    }
  },
  "ReturnValues": "ALL_OLD"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "bookId_delete_success" {
  depends_on = [
    aws_api_gateway_integration.delete_bookId,
    aws_api_gateway_method.delete_bookId,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.bookId.id
  http_method = aws_api_gateway_method.delete_bookId.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "bookId_delete_success" {
  depends_on = [
    aws_api_gateway_integration.delete_bookId,
    aws_api_gateway_method.delete_bookId,
    aws_api_gateway_method_response.bookId_delete_success,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.bookId.id
  http_method = aws_api_gateway_method.delete_bookId.http_method
  status_code = aws_api_gateway_method_response.bookId_delete_success.status_code

  # See more about Velocity Language: https://velocity.apache.org/engine/devel/vtl-reference.html
  # Mapping template variables: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
  response_templates = {
    "application/json" = <<EOF
#set($elem = $input.path('$.Attributes'))
#if($elem.Id.S != "")
{
  "deletedAt": "$context.requestTimeEpoch"
}
#else
    #set($context.responseOverride.status = 404)
{
  "error": "Item not found"
}
#end
EOF
  }
}
