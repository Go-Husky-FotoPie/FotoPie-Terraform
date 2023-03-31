# security group of alb
resource "aws_security_group" "alb_sg" {
    name="alb-sg"
    vpc_id = aws_vpc.main.id
    description = "sg for alb"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    tags = {
      Name = "load balancer sg"
    }
}

#security group for ECS
resource "aws_security_group" "ecs-sg" {
    name = "ecs-sg"
    vpc_id = aws_vpc.main.id
    description = "sg for ecs"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "ECS-security-group"
    }
  
}

#load balancer with target group
resource "aws_lb" "load-balancer" {
    name = "alb"
    internal = false
    load_balancer_type = "application"
    subnets = [ aws_subnet.main-public-1.id,aws_subnet.main-public-2.id ]
    
    security_groups = [
        aws_security_group.alb_sg.id
    ]
    tags = {
      Name = "ALB"
    }
}

#target group for ECS
resource "aws_lb_target_group" "target-group" {
    name = "targetgroup-backend"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.main.id

    health_check {
      healthy_threshold = 2
      interval = 30
      path = "/api/user"
      protocol = "HTTP"
      timeout = 5
      unhealthy_threshold = 2
    }

    tags = {
      Name = "tg-backend"
    }
}


resource "aws_lb_listener" "example" {
    load_balancer_arn = aws_lb.load-balancer.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.target-group.arn
      type = "forward"
    }
}
