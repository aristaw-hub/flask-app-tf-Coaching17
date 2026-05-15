# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
  
  tags = merge(var.tags, {
    Name        = var.cluster_name
    Environment = var.environment
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_tasks" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = var.log_retention_days
  
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.task_family}-execution-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# Attach ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional policy for ECR access
resource "aws_iam_role_policy" "ecs_execution_ecr_policy" {
  name = "ecr-access"
  role = aws_iam_role.ecs_execution_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecs_tasks.arn}:*"
      }
    ]
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = var.custom_task_role_arn != "" ? var.custom_task_role_arn : null
  
  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.container_image
      
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
          hostPort      = var.container_port
        }
      ]
      
      environment = var.container_environment
      
      secrets = var.container_secrets
      
      healthCheck = var.health_check_command != null ? {
        command     = var.health_check_command
        interval    = var.health_check_interval
        timeout     = var.health_check_timeout
        retries     = var.health_check_retries
        startPeriod = var.health_check_start_period
      } : null
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_tasks.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      linuxParameters = {
        initProcessEnabled = true
      }
    }
  ])
  
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# ECS Service
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  
  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }
  
  dynamic "load_balancer" {
    for_each = var.load_balancer_config != null ? [var.load_balancer_config] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }
  
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
  
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
