variable "cost_center" {
  type        = string
  description = "The department code"
}

variable "repo_name" {
  type        = string
  description = "Name of the repository. It will be prepended by cost_center."
}

variable "repo_desc" {
  type        = string
  description = "The repository description."
}

variable "project_name" {
  type        = string
  description = "CodeBuild project name."
}

variable "project_source_version" {
  type        = string
  description = "Version of the build input, it can be branch name, tag name or commit ID"
}
