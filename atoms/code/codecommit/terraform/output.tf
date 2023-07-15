output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}

output "repo_arn" {
  value       = aws_codecommit_repository.repo.arn
  description = "Repository ARN"
}

output "repo_name" {
  value       = local.repo_name
  description = "Repository full name"
}

output "repo_clone_url_http" {
  value       = aws_codecommit_repository.repo.clone_url_http
  description = "Repository HTTPS clone URL"
}

output "repo_clone_url_ssh" {
  value       = aws_codecommit_repository.repo.clone_url_ssh
  description = "Repository SSH clone URL"
}
