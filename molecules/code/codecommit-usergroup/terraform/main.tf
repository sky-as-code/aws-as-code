terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_region" "current" {}

locals {
  aws_region       = data.aws_region.current.name
  cost_center      = var.cost_center
  group_fullaccess = "${local.cost_center}-${var.fullaccess_group}"
  group_readonly   = "${local.cost_center}-${var.readonly_group}"
  repo_name        = var.repo_name
  repo_desc        = var.repo_desc
  policy_prefix    = "${local.cost_center}-${local.repo_name}-codecommit"

  tags = {
    CostCenter = local.cost_center
    Name       = local.repo_name
  }
}

module "codecommit_repo" {
  source = "../../codecommit/terraform"

  cost_center = local.cost_center
  repo_name   = local.repo_name
  repo_desc   = local.repo_desc
}

resource "aws_iam_policy" "fullaccess_policy" {
  name = "${local.policy_prefix}-fullaccess-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowAllActionsOnlyThisRepo"
        Action = [
          "codecommit:*",
        ]
        Effect   = "Allow"
        Resource = module.codecommit_repo.repo_arn
      },
    ]
  })
}

resource "aws_iam_policy" "readonly_policy" {
  name = "${local.policy_prefix}-readonly-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowReadActionsOnlyThisRepo"
        Action = [
          "codecommit:BatchGet*",
          "codecommit:BatchDescribe*",
          "codecommit:Describe*",
          "codecommit:EvaluatePullRequestApprovalRules",
          "codecommit:Get*",
          "codecommit:List*",
          "codecommit:GitPull"
        ]
        Effect   = "Allow"
        Resource = module.codecommit_repo.repo_arn
      },
    ]
  })
}

resource "aws_iam_group" "fullaccess" {
  name = local.group_fullaccess
}

resource "aws_iam_group" "readonly" {
  name = local.group_readonly
}

resource "aws_iam_group_policy_attachment" "fullaccess_attach" {
  group      = aws_iam_group.fullaccess.name
  policy_arn = aws_iam_policy.fullaccess_policy.arn
}

resource "aws_iam_group_policy_attachment" "readonly_attach" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}

#
## We can use AWS-managed policy, but we won't be able to restrict repository ARN.
#
# resource "aws_iam_group_policy_attachment" "fullaccess-attach" {
#   group      = aws_iam_group.fullaccess.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess" # https://docs.aws.amazon.com/codecommit/latest/userguide/security-iam-awsmanpol.html#managed-policies-full
# }

# resource "aws_iam_group_policy_attachment" "readonly-attach" {
#   group      = aws_iam_group.readonly.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly" # https://docs.aws.amazon.com/codecommit/latest/userguide/security-iam-awsmanpol.html#managed-policies-read
# }
