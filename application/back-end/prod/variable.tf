variable "vpc_name" {
    description = "vpc name"
    type = string
    default = "fotopie-vpc"
}

variable "vpc_cidr_block" {
    description = "cidr block for vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
    description = "cidr block for private subnets" 
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_cidr" {
    description = "cidr block for public subnets" 
    type = list(string)
    default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs_zone" {
    description = "vpc zones"
    default = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "environment" {
    description = "infrastructure enviroment"
}

variable "alb_security_group_name" {
    description = "security group name for alb"
    type = string
    default = "fotopie_lb_sg"
}

variable "ecs_security_group_name" {
    description = "security group name for ecs"
    type = string
    default = "fotopie_ecs_sg"
}

variable "alb_name" {
    description = " application load balacer name "
    type = string
    default = "fotopie-ALB"
}

variable "target_groups_name" {
    description = "target groups name "
    type = string
    default = "fotopie-tg-backend"
}

variable "load_balancer_type" {
    description = " type of load balancer "
    default = "application"
}

variable "alb_protocol" {
  description = "protocol for alb listeners"
  default     = "HTTP"
}

variable "target_group_protocol" {
  description = "protocol for target group"
  default     = "HTTP"
}

variable "target_group_type" {
  description = "target type"
  default     = "ip"
}

variable "health_check_path" {
  default = "/api/user"
}

 variable "cluster_name" {
    description = "ECS cluster name"
    type = string
    default = "fotopie-backend-cluster"
}

variable "ecs_task_definition_family_name" {
    description = "ECS task definition family name"
    type = string
    default = "fotopie"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 2048
}

variable "ecs_container_name" {
  description = "ecs service container name"
  type = string
  default     = "fotopie"
}

variable "app_image" {
   description  = "Docker image to run in the ECS cluster"
   default      = "271584491311.dkr.ecr.ap-southeast-2.amazonaws.com/node-app:latest"
}

variable "container_cpu" {
   default     = 128
}

variable "container_memory" {
   default     = 256
}

variable "container_port" {
   default     = 3000
}

variable "container_protocol" {
  description = "protocol for container portMappings"
  default     = "tcp"
}

variable "ecs_service_name" {
    description = "ECS service name"
    type = string
    default = "fotopie-backend-service"
}

variable "ecs_service_app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

