vpc_name = "fotopie-vpc-uat"

vpc_cidr_block = "10.0.0.0/16"

private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]

public_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]

environment = "uat"

alb_security_group_name = "fotopie_lb_sg_uat"

ecs_security_group_name = "fotopie_ecs_sg_uat"

alb_name = "fotopie-ALB-uat"

target_groups_name = "fotopie-tg-uat"

cluster_name = "fotopie-cluster-uat"

ecs_task_definition_family_name = "fotopie-task-defination-uat"

ecs_container_name = "fotopie-uat"

ecs_service_name = "fotopie-backend-service-uat"