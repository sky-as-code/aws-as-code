
resource "aws_iam_policy" "codebuild_common" {
  name        = "${local.cost_center}-codebuild-common-policy"
  description = "Common policy for all CodeBuild projects"

  # Alternatively, we can use aws_iam_policy_document 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "*"
        ],
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
      },
    ]
  })
}

resource "aws_iam_role" "codebuild_role" {
  name = "${local.project_full_name}-codebuild-role"
  managed_policy_arns = [
    aws_iam_policy.codebuild_common.arn,
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.tags, {
    Name = "${local.project_full_name}-codebuild-role"
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  # name   = "${local.project_full_name}-codebuild-policy"

  # CodeBuild always automatically create an IAM policy with this name,
  # and Terraform doesn't delete it on destroy.
  # So we override this behavior so that Terraform will delete it.
  name = "CodeBuildBasePolicy-${local.project_full_name}-${local.aws_region}"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

#
## Alternatively, we can use AWS-managed policy, but we won't be able to restrict repository ARN.
#
# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.codebuild_role.id
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
# }

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid     = "AllowAllActionsOnSpecifiedRepo"
    effect  = "Allow"
    actions = ["codecommit:Get*"]
    resources = [
      module.codecommit_repo.repo_arn,
    ]
  }

  statement {
    sid     = "AllowReportGroupActions"
    effect  = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:${local.aws_region}:${local.aws_account_id}:report-group/${local.project_full_name}-*"
    ]
  }
}