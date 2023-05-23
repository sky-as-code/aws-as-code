resource "aws_iam_role" "apigateway_role" {
  name = "${local.prefix}-apigateway-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${local.prefix}-apigateway-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "GrantDynamoDbPermissions"
          Effect = "Allow"
          Action = [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query",
            "dynamodb:UpdateItem"
          ]
          Resource = "${aws_dynamodb_table.ddb_books.arn}*"
        },
        {
          Sid    = "GrantCloudWatchPermissions"
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
          ],
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(local.tags, {
    Name = "${local.prefix}-apigateway-policy"
  })
}