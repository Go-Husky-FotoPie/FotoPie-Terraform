# creates VPC resources
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

# create secutiry group for application load balancer and ecs srevise
module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  
  name        = var.alb_security_group_name
  description = "Security group for application load balancer"
  vpc_id      = module.vpc.vpc_id 

  ingress_with_cidr_blocks = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]
  tags = {
    Name = var.alb_security_group_name
  }
}

module "ecs_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  
  name        = var.ecs_security_group_name
  description = "Security group for ECS service"
  vpc_id      = module.vpc.vpc_id 

  ingress_with_source_security_group_id = [
    {
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      source_security_group_id  = module.alb_security_group.security_group_id
    }
  ]
  
  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
    }
  ] 
  tags = {
    Name = var.ecs_security_group_name
  } 
}

# create application load balancer with a target group
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.alb_name

  load_balancer_type = var.load_balancer_type

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets 
  security_groups    = [module.alb_security_group.security_group_id]
  
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = var.alb_protocol
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = var.target_groups_name
      backend_protocol = var.target_group_protocol
      backend_port     = 80
      target_type      = var.target_group_type
      health_check = {
      healthy_threshold   = 2
      interval            = 30
      path                = var.health_check_path
      port                = "traffic-port"
      protocol            = var.target_group_protocol
      timeout             = 5
      unhealthy_threshold = 2
    }
   }
 ]
  create_security_group = false // aviod module "alb" creating default security group 'terraform-module-ALB'
}

# task_role & tast_execution_role already created 
data "aws_iam_role" "existing_ecs_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "existing_ecs_task_role" {
  name = "ecsTaskExecutionRole"
}

# Create ESC Cluster
  resource "aws_ecs_cluster" "fotopie_backend_cluster" {
    name = var.cluster_name
    
    tags = {
      Environment = var.environment
    }
  }

# Create cloudwatch log
  resource "aws_cloudwatch_log_group" "fotopie_logs_group" {
  name = "/ecs/fotopie"

  tags = {
    Name = "fotopie-log-group"
  }
}

 resource "aws_cloudwatch_log_stream" "fotopie_logs_stream" {
  name           = "fotopie-log-stream"
  log_group_name = aws_cloudwatch_log_group.fotopie_logs_group.name
}

# create task definition
  resource "aws_ecs_task_definition" "fotopie" {
    family                   = var.ecs_task_definition_family_name
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory

# task_role & tast_execution_role already created
    execution_role_arn   = data.aws_iam_role.existing_ecs_execution_role.arn
    task_role_arn        = data.aws_iam_role.existing_ecs_task_role.arn

# # when first create task_role & tast_execution_role
#     execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
#     task_role_arn             = aws_iam_role.ecs_task_role.arn


    container_definitions = jsonencode([
       {
          "name":   var.ecs_container_name
          "image":  var.app_image,
          "cpu":    var.container_cpu,
          "memory": var.container_memory,
          "logConfiguration": {
                  "logDriver": "awslogs",
                  "options": {
                      "awslogs-region" : "ap-southeast-2",
                      "awslogs-group" : "/ecs/fotopie",
                      "awslogs-stream-prefix" : "ecs"
                   }
                }
          "portMappings": [
           {
              "containerPort": var.container_port,
              "protocol": var.container_protocol
              "hostPort": var.container_port
            }
          ]
        }
      ])
    }

 # Create aws_ecs_service
  resource "aws_ecs_service" "fotopie_backend_service" {
    name                         = var.ecs_service_name
    cluster                      = aws_ecs_cluster.fotopie_backend_cluster.id
    task_definition              = aws_ecs_task_definition.fotopie.arn
    desired_count                = var.ecs_service_app_count
    scheduling_strategy          = "REPLICA"
    launch_type                  = "FARGATE"

    network_configuration {
      security_groups  = [module.ecs_security_group.security_group_id]
      subnets          = module.vpc.private_subnets
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = module.alb.target_group_arns[0]
      container_name   = var.ecs_container_name
      container_port   = var.container_port
     }
  }
  


# # Create IAM ECS Task Execution Role at first time 
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"
 
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }


# # Attach the ECS task execution role policy to the ECS task execution role
# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#    role       = aws_iam_role.ecs_task_execution_role.name
# }





