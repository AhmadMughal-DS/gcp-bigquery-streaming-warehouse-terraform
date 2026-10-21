locals {
  name_prefix = var.project_name
}

module "warehouse" {
  source      = "./modules/warehouse"
  name_prefix = local.name_prefix
  project_id  = var.project_id
  environment = var.environment
}
