# Parameter group for Redis configuration
resource "aws_elasticache_parameter_group" "redis" {
  family = "redis7"
  name   = "${var.app_name}-${var.environment}-redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

# Subnet group for Redis clusters
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.app_name}-${var.environment}-redis-subnet"
  subnet_ids = var.subnet_ids
}

# Redis replication group for high availability
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.app_name}-${var.environment}-redis"
  description         = "Redis cluster for ${var.app_name}"
  node_type                    = "cache.t3.medium"
  port                         = 6379
  parameter_group_name         = aws_elasticache_parameter_group.redis.name
  subnet_group_name            = aws_elasticache_subnet_group.redis.name
  security_group_ids           = [var.security_group_id]
  
  automatic_failover_enabled    = true
  multi_az_enabled             = true
  num_cache_clusters           = 2
  
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-redis"
    Environment = var.environment
  }
}

# Store Redis auth token in Secrets Manager
resource "aws_secretsmanager_secret" "redis_auth" {
  name = "${var.app_name}-${var.environment}-redis-auth"
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id     = aws_secretsmanager_secret.redis_auth.id
  secret_string = random_password.redis_auth.result
}

resource "random_password" "redis_auth" {
  length  = 16
  special = true
}