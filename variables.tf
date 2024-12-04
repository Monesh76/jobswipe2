variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}
variable "availability_zones" {
  description = "Availability zones in us-west-1"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]  # us-west-1 has two AZs
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "jobswipe"
}