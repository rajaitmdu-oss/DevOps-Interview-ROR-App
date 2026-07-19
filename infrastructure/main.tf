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

module "alb" {

  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_group.alb_security_group_id
}

module "ecs_task" {

  source = "./modules/ecs-task"

  project_name = var.project_name
  environment  = var.environment

  aws_region = var.aws_region

  repository_url = module.ecr.repository_url

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  log_group_name = module.cloudwatch.log_group_name
}

module "aws_ecs_service" {

  source = "./modules/ecs-service"

  project_name = var.project_name
  environment  = var.environment

  cluster_id          = module.ecs.cluster_id
  task_definition_arn = module.ecs_task.task_definition_arn

  target_group_arn = module.alb.target_group_arn

  ecs_security_group_id = module.security_group.ecs_security_group_id

  private_app_subnet_ids = module.vpc.private_app_subnet_ids
}