variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Redis"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for Redis"
  type        = string
}