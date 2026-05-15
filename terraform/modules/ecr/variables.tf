variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "force_delete" {
  description = "Force delete repository even if it contains images"
  type        = bool
  default     = true
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "lifecycle_policy_enabled" {
  description = "Enable lifecycle policy for image cleanup"
  type        = bool
  default     = false
}

variable "keep_last_images" {
  description = "Number of latest images to keep"
  type        = number
  default     = 10
}

variable "max_image_age_days" {
  description = "Maximum age of images in days before cleanup"
  type        = number
  default     = 90
}

variable "repository_policy" {
  description = "Custom repository policy JSON"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
