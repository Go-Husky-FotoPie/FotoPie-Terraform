environment = "prod"
fotopie_vpc = "fotopie-vpc-prod"
single_nat_gateway = false
application-loadbalancer-security-group = "alb-sg-prod"
ecs-service-security-group = "ecs-sg-prod"
grafana-security-group = "fotopie_grafana_sg_prod"
cluster_name = "FotoPie-with-Fargate-prod"
ecs-task-execution-role = "ecs-task-execution-role-prod"
ecr-policy-name = "ecr-policy-prod"
task_definition_family_name = "fotopie_backend_task_prod"
image_name = "fotopie-backend-prod"
image_uri = "123436089261.dkr.ecr.ap-southeast-2.amazonaws.com/fotopie-prod:latest"
ecs_service_name = "fotopie_service_prod"
container_name = "fotopie-backend-prod"
grafana_name = "fotopie-backend-prod"
fotopieAlb_name = "fotopieALB-prod"
fotopie_target_group_name = "fotopieTargetGroup-prod"
fotopie_alb_sg = "fotopie_alb_sg_prod"
fotopie_ecs_service_sg = "fotopie_ecs_service_sg_prod"
domain_name = "fotopie.net"
