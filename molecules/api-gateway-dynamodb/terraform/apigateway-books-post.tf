resource "aws_api_gateway_method" "post_book" {
  rest_api_id          = aws_api_gateway_rest_api.restapi.id
  resource_id          = aws_api_gateway_resource.books.id
  http_method          = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_book" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.post_book.http_method

  type                    = "AWS"
  credentials             = aws_iam_role.apigateway_role.arn
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${local.aws_region}:dynamodb:action/UpdateItem"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${aws_dynamodb_table.ddb_books.name}",
  "Key": {
    "Id": {
      "S": "$context.requestId"
    }
  },
  "UpdateExpression": "SET Title=:title,Isbn=:isbn,Author=:author,CreatedAt=:createdAt,UpdatedAt=:updatedAt",
  "ExpressionAttributeValues": {
    ":title": {
      "S": "$input.path('$.title')"
    },
    ":isbn": {
      "S": "$input.path('$.isbn')"
    },
    ":author": {
      "S": "$input.path('$.author')"
    },
    ":createdAt": {
      "N": "$context.requestTimeEpoch"
    },
    ":updatedAt": {
      "N": "$context.requestTimeEpoch"
    }
  },
  "ReturnValues": "ALL_NEW"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "books_post_success" {
  depends_on = [
    aws_api_gateway_integration.post_book,
    aws_api_gateway_method.post_book,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.post_book.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "books_post_success" {
  depends_on = [
    aws_api_gateway_integration.post_book,
    aws_api_gateway_method.post_book,
    aws_api_gateway_method_response.books_post_success,
  ]

  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.post_book.http_method
  status_code = aws_api_gateway_method_response.books_post_success.status_code

  # See more about Velocity Language: https://velocity.apache.org/engine/devel/vtl-reference.html
  # Mapping template variables: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
  response_templates = {
    "application/json" = <<EOF
#set($elem = $input.path('$.Attributes'))
{
  "id": "$elem.Id.S",
  "title": "$elem.Title.S",
  "isbn": "$elem.Isbn.S",
  "author": "$elem.Author.S",
  "createdAt": "$elem.CreatedAt.N",
  "updatedAt": "$elem.UpdatedAt.N"
}
EOF
  }
}
