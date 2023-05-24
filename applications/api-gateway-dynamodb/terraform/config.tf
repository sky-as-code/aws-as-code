locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.name
  app_name       = var.app_name
  cost_center    = var.cost_center
  env_name       = var.environment_name
  prefix         = "${local.cost_center}-${local.app_name}-${local.env_name}"
  prefix_short   = "${local.cost_center}-${local.env_name}"

  configsMap = {
    dev = {
      env_type = "nonprod"
    }
    sit = {
      env_type = "nonprod"
    }
    prod = {
      env_type = "prod"
    }
  }

  configs = local.configsMap[local.env_name]

  tags = {
    Application     = local.app_name
    CostCenter      = local.cost_center
    EnvironmentName = local.env_name
    EnvironmentType = local.configs["env_type"]
  }
}
