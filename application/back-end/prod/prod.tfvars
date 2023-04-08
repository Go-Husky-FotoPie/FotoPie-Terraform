vpc_name = "fotopie-vpc-prod"

vpc_cidr_block = "10.0.0.0/16"

private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]

public_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

environment = "prod"

alb_security_group_name = "fotopie_lb_sg_prod"

ecs_security_group_name = "fotopie_ecs_sg_prod"

alb_name = "fotopie-ALB-prod"

target_groups_name = "fotopie-tg-prod"

cluster_name = "fotopie-cluster-prod"

ecs_task_definition_family_name = "fotopie-task-defination-prod"

ecs_container_name = "fotopie-prod"

ecs_service_name = "fotopie-backend-service-prod"