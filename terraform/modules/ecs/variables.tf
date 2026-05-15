variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "task_family" {
  description = "Task definition family name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = true
}

variable "container_environment" {
  description = "Environment variables for container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "container_secrets" {
  description = "Secrets for container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "health_check_command" {
  description = "Health check command"
  type        = list(string)
  default     = null
}

variable "health_check_interval" {
  description = "Health check interval (seconds)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout (seconds)"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "Health check retries"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "Health check start period (seconds)"
  type        = number
  default     = 60
}

variable "deployment_minimum_healthy_percent" {
  description = "Deployment minimum healthy percent"
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Deployment maximum percent"
  type        = number
  default     = 200
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention days"
  type        = number
  default     = 30
}

variable "custom_task_role_arn" {
  description = "Custom task role ARN (optional)"
  type        = string
  default     = ""
}

variable "load_balancer_config" {
  description = "Load balancer configuration"
  type = object({
    target_group_arn = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
