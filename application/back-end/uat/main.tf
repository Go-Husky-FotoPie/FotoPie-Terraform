module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = var.azs_zone
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway = true
  create_igw = true

  tags = {
     Terraform = "true"
     Environment = var.environment
  }
}



module "networking_ecs" {
  source = "../../../modules/backend"

  vpc_name = var.vpc_name

  vpc_cidr_block = var.vpc_cidr_block

  private_subnets_cidr = var.private_subnets_cidr

  public_subnets_cidr = var.public_subnets_cidr

  environment = var.environment

  alb_security_group_name = var.alb_security_group_name

  ecs_security_group_name = var.ecs_security_group_name

  alb_name = var.alb_name

  target_groups_name = var.target_groups_name

  cluster_name = var.cluster_name

  ecs_task_definition_family_name = var.ecs_task_definition_family_name

  ecs_container_name = var.ecs_container_name

  ecs_service_name = var.ecs_service_name
  
 }

