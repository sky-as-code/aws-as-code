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
  aws_region     = data.aws_region.current.name
  cost_center    = var.cost_center
  repo_name      = "${local.cost_center}-${var.repo_name}"
  repo_desc      = var.repo_desc

  tags = {
    CostCenter = local.cost_center
    Name       = local.repo_name
  }
}

resource "aws_codecommit_repository" "repo" {
  repository_name = local.repo_name
  description     = local.repo_desc
  tags            = local.tags
}
