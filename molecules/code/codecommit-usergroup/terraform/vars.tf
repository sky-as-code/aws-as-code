variable "cost_center" {
  type        = string
  description = "The department code"
}

variable "fullaccess_group" {
  type        = string
  description = "User group name that has full access to the CodeCommit repository."
}

variable "readonly_group" {
  type        = string
  description = "User group name that has readonly access to the CodeCommit repository."
}

variable "repo_name" {
  type        = string
  description = "Name of the repository. It will be prepended by cost_center."
}

variable "repo_desc" {
  type        = string
  description = "The repository description."
}
