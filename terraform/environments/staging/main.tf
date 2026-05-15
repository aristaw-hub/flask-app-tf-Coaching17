# Staging Environment Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "arista-terraform-state-bucket"
    key            = "flask-app-infra/staging/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "flask-app"
}

variable "environment" {
  default = "staging"
}

variable "vpc_id" {}
variable "subnet_ids" {}
variable "container_port" {
  default = 8080
}
variable "task_cpu" {
  default = 512
}
variable "task_memory" {
  default = 1024
}
variable "desired_count" {
  default = 2
}
