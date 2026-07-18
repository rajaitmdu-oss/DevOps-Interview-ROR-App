module "vpc" {

  source = "./modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_app_subnets = var.private_app_subnets
  private_db_subnets  = var.private_db_subnets

}

module "security_group" {

  source = "./modules/security-group"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id
}