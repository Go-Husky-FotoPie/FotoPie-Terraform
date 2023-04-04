#create ecs
resource "aws_ecs_cluster" "test" {
    name = "test"
  
}

#create cloudwatch 
resource "aws_cloudwatch_log_group" "log-group" {
    name = "/ecs/foto"
  
}

resource "aws_cloudwatch_log_stream" "log_stream" {
    name="log-stream"
    log_group_name = aws_cloudwatch_log_group.log-group.name 
}

#create task definition 
resource "aws_ecs_task_definition" "task-foto" {
    family = "task-foto"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu   = "1024"
    memory = "2048"

    execution_role_arn = "arn:aws:iam::190177667055:role/ecsTaskExecutionRole"

    task_role_arn  = "arn:aws:iam::190177667055:role/ecsTaskExecutionRole"

    container_definitions = jsonencode([
        {
        name      = "tmp3"
        image     = "190177667055.dkr.ecr.us-east-1.amazonaws.com/tmp3:latest"
        
        cpu       = 10
        memory    = 512
        essential = true
        
        environment = [
                {
                    "name": "ACCESS_TOKEN_SECRET_PUBLIC",
                    "value": "-----BEGIN PUBLIC KEY-----MIICITANBgkqhkiG9w0BAQEFAAOCAg4AMIICCQKCAgBjNu1Hyk4NBORBj6xS0QcwdLhFC9PMoGi0a5DcQ06YiihppphWF7rTRZnmne1EN4xD2xO38od2vgAVNCtMoQ5RQaVaRwMolY96d6awc3+dXb4oAR/AQvdu73wPDSwMJd7YcO1TUS3xElkD02+EcHXr1wz1NhfC/M6wRFP2fX9+A9RaKo8t1FsrCfjek+SEezSAvtv9JBF7ZyNEO+8V2igojl2P6YEPLGR/juWa6ebU1mbga0zz8J7MGvelGxDg/ghgCLgzwRfWdJJUbYoMnJUXXeIHUyDj8RNt7yZc85iRxeKUbeLhqX8miIkRHKWt6IKqq5gaRrdVHtBieAfoG9t4mmhCNvDE/jNZoLum2IbTYOkzGEqVcLuvIzOaX1+mw89z8lrqsSffweCEBEO7meUXhvcYx5fTSVriCqhbNr7dZfMoQUMdlj458bIse9oQg6+EcUMo3WuSzIA4NFu4jsCuQIGSNR+TThXq6Y8APAn+y/TgGljFEIsJ7o9tMKLzEMOI21UiHZPmRmn6S50jvHSfkHxZ5SBXHEoFYfvOt6b+YenuBGA7sXRTXr5jBVLTJdZHLqhBu7fXS0sdEyk5yBZoFzgZx+IIx3X2qbNS4JFUAqg/BQmNM7qzOoImO1EUv/IjTjVDW9IT0nQnfFAgJxV/MzR3vkbkp5UoGy2RCcg2eQIDAQAB-----END PUBLIC KEY-----"
                },
                {
                    "name": "REFRESH_TOKEN_SECRET_PRIVATE",
                    "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----"
                },
                
              
                {
                    "name": "ACCESS_TOKEN_SECRET_PRIVATE",
                    "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----"
                },
                
                
               
                {
                    "name": "REFRESH_TOKEN_SECRET_PUBLIC",
                    "value": "-----BEGIN PUBLIC KEY-----MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAh8N7XybcGeueFhA96RNkXrtH2XrKsJxD4FX9WKl0wGshPyXh4k+gvN904TU6yqGhqLBvStXHkK674XARougv/E0RTV5AhEgWSYggRA954svm63UiqfHv77ghof8tY58aT6Ov0rA+2Y2K046yPb2w2WkoXgaYssPCsS+PEdZRH56uO3CCrX/QVSJZ52UuUant2V+vZr37M/0iQWmI2x3pOsIsxqLkj9s0cyK5+xBHKrwpRlYxOPD75dYK6WpEEJzhieO68SbwkIViCLMu48AmjHE6XJmRnqAVmfO2f/fGTx/AgFCnoIWO3bxrQRWLj7KL0s1ucZu0PWVUHZm8PsFviY3D1yDh5RTXBglRBPAjqVOTX9R6aQiciGlrOyOrgFbfPAm/f617fyK+fLCUf1tPBGyTNnhCC+PaOXmGBiysZZGWLpMnc7JY0ovruDd6vRegugaE4rDyT0ip/JSU3VM/de1rue6Dmr4tVhdQBwpQBdRZ3KfkNvtc9QVTlfbd8uhd340TA1gJO2HXGAFVE5z8CAfIJbJN9gRKXWIz7NGHpHr1iSdVJin9qU0uE+ZO9vWKFROmX5E8LjT2WLhqovc0y88RyotiyLgPb4v6Wb0MBn1c9Hvzl1Nz+UjzHA7V+Dx/aqqcJx+KUp/1buM2b7N73J3W9YPq/ZQiBbkKah3EOiECAwEAAQ==-----END PUBLIC KEY-----"
                },

            ],
        logConfiguration= {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "/ecs/foto",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }

        

        requiresAttributes = [
            {
            "name": "com.amazonaws.ecs.capability.logging-driver.awslogs"
        },
        {
            "name": "ecs.capability.execution-role-awslogs"
        },
        {
            "name": "com.amazonaws.ecs.capability.ecr-auth"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.19"
        },
        {
            "name": "com.amazonaws.ecs.capability.task-iam-role"
        },
        {
            "name": "ecs.capability.execution-role-ecr-pull"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
        },
        {
            "name": "ecs.capability.task-eni"
        },
        {
            "name": "com.amazonaws.ecs.capability.docker-remote-api.1.29"
        }
        ]
        


        portMappings = [
            {
            containerPort = 9090
            hostPort      = 9090
            protocol = "tcp",
            }
      ]
    }])
}


#ecs-service


resource "aws_ecs_service" "ecs-service" {
    cluster=aws_ecs_cluster.test.arn
    name = "service-name"
    
    task_definition = aws_ecs_task_definition.task-foto.arn
    #task_definition = "arn:aws:ecs:us-east-1:190177667055:task-definition/latest:9"
    desired_count = 2
    scheduling_strategy = "REPLICA"
    launch_type = "FARGATE"

    network_configuration {
      security_groups = [aws_security_group.ecs-sg.id]
      subnets = [aws_subnet.main-private-2.id]
      assign_public_ip = true

    }

    load_balancer {
      target_group_arn = aws_lb_target_group.target-group.arn
      container_name = "tmp3"
      container_port = 9090
    }
  
  
}

