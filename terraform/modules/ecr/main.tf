terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ECR Repository
resource "aws_ecr_repository" "this" {
  name         = var.repository_name
  force_delete = var.force_delete
  
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  
  tags = merge(var.tags, {
    Name        = var.repository_name
    Environment = var.environment
  })
}

# ECR Lifecycle Policy (separate resource)
resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name
  
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.keep_last_images} images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = var.keep_last_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images older than ${var.max_image_age_days} days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = var.max_image_age_days
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ECR Repository Policy (separate resource)
resource "aws_ecr_repository_policy" "this" {
  count      = var.repository_policy != null ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy
}
