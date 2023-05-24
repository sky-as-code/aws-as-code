resource "aws_dynamodb_table" "ddb_books" {
  name         = "${local.prefix}-books-ddb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = merge(local.tags, {
    Name = "${local.prefix}-books-ddb"
  })
}
