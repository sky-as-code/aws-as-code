output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}

output "repo_arn" {
  value       = module.codecommit_repo.repo_arn
  description = "CodeCommit repository ARN"
}

output "repo_name" {
  value       = module.codecommit_repo.repo_name
  description = "CodeCommit repository full name"
}

output "repo_clone_url_http" {
  value       = module.codecommit_repo.repo_clone_url_http
  description = "CodeCommit repository HTTPS clone URL"
}

output "repo_clone_url_ssh" {
  value       = module.codecommit_repo.repo_clone_url_ssh
  description = "CodeCommit repository SSH clone URL"
}

output "project_arn" {
  value       = aws_codebuild_project.build_project.arn
  description = "CodeBuild project ARN"
}

output "project_name" {
  value       = aws_codebuild_project.build_project.name
  description = "CodeBuild project full name"
}
