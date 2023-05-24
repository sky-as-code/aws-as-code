resource "aws_api_gateway_method" "get_book" {
  rest_api_id          = aws_api_gateway_rest_api.restapi.id
  resource_id          = aws_api_gateway_resource.books.id
  http_method          = "GET"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.cognito.id
  authorization_scopes = [local.scope_books]
}

resource "aws_api_gateway_integration" "get_book" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.get_book.http_method

  type                    = "AWS"
  credentials             = aws_iam_role.apigateway_role.arn
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${local.aws_region}:dynamodb:action/Scan"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${aws_dynamodb_table.ddb_books.name}"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "books_get_success" {
  depends_on = [
    aws_api_gateway_integration.get_book,
    aws_api_gateway_method.get_book,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.get_book.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "books_get_success" {
  depends_on = [
    aws_api_gateway_integration.get_book,
    aws_api_gateway_method.get_book,
    aws_api_gateway_method_response.books_get_success,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.get_book.http_method
  status_code = aws_api_gateway_method_response.books_get_success.status_code

  # See more about Velocity Language: https://velocity.apache.org/engine/devel/vtl-reference.html
  # Mapping template variables: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
[
  #foreach($elem in $inputRoot.Items) {
    "id": "$elem.Id.S",
    "title": "$elem.Title.S",
    "isbn": "$elem.Isbn.S",
    "author": "$elem.Author.S",
    "createdAt": "$elem.CreatedAt.N",
    "updatedAt": "$elem.UpdatedAt.N"
  }#if($foreach.hasNext),#end
	#end
]
EOF
  }
}
