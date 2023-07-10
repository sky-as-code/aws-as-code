output "repo_arn" {
  value       = aws_codecommit_repository.repo.arn
  description = "Repository ARN"
}

output "repo_name" {
  value       = local.repo_name
  description = "Repository full name"
}

output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}