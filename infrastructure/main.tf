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

module "rds" {

  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  private_db_subnet_ids = module.vpc.private_db_subnet_ids

  rds_security_group_id = module.security_group.rds_security_group_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "ecr" {

  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "ecs" {

  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
}

module "iam" {

  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "cloudwatch" {

  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
}