variable "app_name" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "environment_name" {
  type        = string
  description = "Possible values: dev, sit, prod"
}
