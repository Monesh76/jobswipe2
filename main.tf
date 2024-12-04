provider "aws" {
  region = "us-west-1"  # You can change this to your preferred region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Create the VPC first
module "vpc" {
  source = "./modules/vpc"
  
  app_name    = "jobswipe"
  environment = "dev"
  cidr_block  = "10.0.0.0/16"
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  #availability_zones   = var.availability_zones
  availability_zones   = ["us-west-1b", "us-west-1c"]
}
module "eks" {
  source = "./modules/eks"
  
  app_name    = var.app_name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids  # We use private subnets for the EKS nodes
}
module "databases" {
  source = "./modules/databases"
  
  app_name         = var.app_name
  environment      = var.environment
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_id = module.vpc.database_security_group_id
}

# Redis for caching and real-time features
module "redis" {
  source = "./modules/redis"
  
  app_name         = var.app_name
  environment      = var.environment
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_id = module.vpc.redis_security_group_id
}

# S3 buckets and storage configuration
module "storage" {
  source = "./modules/storage"
  
  app_name    = var.app_name
  environment = var.environment
}

# CloudWatch monitoring setup
module "monitoring" {
  source = "./modules/monitoring"
  
  app_name        = var.app_name
  environment     = var.environment
  eks_cluster_name = module.eks.cluster_name
  alb_name        = module.eks.alb_name
}
output "database_endpoints" {
  description = "Database endpoint information"
  value = {
    profile_db = module.databases.profile_db_endpoint
    match_db   = module.databases.match_db_endpoint
  }
  sensitive = true
}

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = module.redis.endpoint
  sensitive   = true
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

