output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}

output "group_fullaccess" {
  value       = aws_iam_group.fullaccess.name
  description = "Group full name that has full access to repository"
}

output "group_readonly" {
  value       = aws_iam_group.readonly.name
  description = "Group full name that has full access to repository"
}

output "repo_arn" {
  value       = module.codecommit_repo.repo_arn
  description = "Repository ARN"
}

output "repo_name" {
  value       = module.codecommit_repo.repo_name
  description = "Repository full name"
}