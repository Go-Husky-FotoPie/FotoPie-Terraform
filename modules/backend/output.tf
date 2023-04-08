output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "alb_security_group_id" {
  value = module.alb_security_group.security_group_id
}

output "ecs_security_group_id" {
  value = module.ecs_security_group.security_group_id
}

output "target_group_arn" {
  value = module.alb.target_group_arns[0]
}