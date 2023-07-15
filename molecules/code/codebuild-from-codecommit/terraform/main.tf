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

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region       = data.aws_region.current.name
  cost_center      = var.cost_center

  # For CodeCommit
  repo_name     = var.repo_name
  repo_desc     = var.repo_desc
  policy_prefix = "${local.cost_center}-${local.repo_name}-codecommit"

  # For CodeBuild
  project_name           = var.project_name
  project_full_name      = "${local.cost_center}-${local.project_name}"
  project_source_version = var.project_source_version

  tags = {
    CostCenter = local.cost_center
  }
}

module "codecommit_repo" {
  source = "../../codecommit/terraform"

  cost_center = local.cost_center
  repo_name   = local.repo_name
  repo_desc   = local.repo_desc
}


resource "aws_codebuild_project" "build_project" {
  name           = local.project_full_name
  description    = "Build project for repo ${local.repo_name}, on branch ${local.project_source_version}, no artifact and deployment."
  build_timeout  = 5 # Minutes
  service_role   = aws_iam_role.codebuild_role.arn
  source_version = "refs/heads/${local.project_source_version}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      # We can just provide a log group name and CodeBuild will automatically create one for us.
      # However this log group isn't automatically deleted on Terraform destroy.
      # Therefore we create a log group ourselves so that Terraform will delete it.
      group_name  = aws_cloudwatch_log_group.build_log.name
      stream_name = "${local.project_full_name}-log-stream"
    }
  }

  source {
    type     = "CODECOMMIT"
    # Must be HTTPS URL. Source: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectSource.html#CodeBuild-Type-ProjectSource-location
    location = module.codecommit_repo.repo_clone_url_http

    # Only fetch latest commit
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = merge(local.tags, {
    Name = "${local.cost_center}-${local.project_name}-codebuild-role"
  })
}

resource "aws_cloudwatch_log_group" "build_log" {
  name = "${local.project_full_name}-codebuild"

  tags = merge(local.tags, {
    Name = "${local.project_full_name}-codebuild"
  })
}