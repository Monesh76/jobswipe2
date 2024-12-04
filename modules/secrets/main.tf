# modules/secrets/main.tf

# Create random passwords for various services
resource "random_password" "profile_db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "match_db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "redis_auth" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "jwt_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create secrets for database credentials
resource "aws_secretsmanager_secret" "profile_db" {
  name = "${var.app_name}-${var.environment}-profile-db-credentials"
  description = "Credentials for Profile Database"
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-profile-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "profile_db" {
  secret_id = aws_secretsmanager_secret.profile_db.id
  secret_string = jsonencode({
    username = "profile_admin"
    password = random_password.profile_db.result
    host     = var.profile_db_host
    port     = "5432"
    dbname   = "profile_db"
  })
}

resource "aws_secretsmanager_secret" "match_db" {
  name = "${var.app_name}-${var.environment}-match-db-credentials"
  description = "Credentials for Match Database"
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-match-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "match_db" {
  secret_id = aws_secretsmanager_secret.match_db.id
  secret_string = jsonencode({
    username = "match_admin"
    password = random_password.match_db.result
    host     = var.match_db_host
    port     = "5432"
    dbname   = "match_db"
  })
}

# Create secret for Redis authentication
resource "aws_secretsmanager_secret" "redis" {
  name = "${var.app_name}-${var.environment}-redis-credentials"
  description = "Credentials for Redis Cache"
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-redis-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "redis" {
  secret_id = aws_secretsmanager_secret.redis.id
  secret_string = jsonencode({
    auth_token = random_password.redis_auth.result
    host       = var.redis_host
    port       = "6379"
  })
}

# Create secret for JWT authentication
resource "aws_secretsmanager_secret" "jwt" {
  name = "${var.app_name}-${var.environment}-jwt-secret"
  description = "Secret for JWT token signing"
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-jwt-secret"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id = aws_secretsmanager_secret.jwt.id
  secret_string = jsonencode({
    secret = random_password.jwt_secret.result
  })
}

# IAM policy for accessing secrets
resource "aws_iam_policy" "secrets_access" {
  name        = "${var.app_name}-${var.environment}-secrets-access"
  description = "Policy for accessing application secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.profile_db.arn,
          aws_secretsmanager_secret.match_db.arn,
          aws_secretsmanager_secret.redis.arn,
          aws_secretsmanager_secret.jwt.arn
        ]
      }
    ]
  })
}

# Variables
variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "profile_db_host" {
  description = "Host address for the profile database"
  type        = string
}

variable "match_db_host" {
  description = "Host address for the match database"
  type        = string
}

variable "redis_host" {
  description = "Host address for Redis"
  type        = string
}

# Outputs
output "secrets_policy_arn" {
  description = "ARN of the secrets access IAM policy"
  value       = aws_iam_policy.secrets_access.arn
}

output "profile_db_secret_arn" {
  description = "ARN of the profile database credentials secret"
  value       = aws_secretsmanager_secret.profile_db.arn
}

output "match_db_secret_arn" {
  description = "ARN of the match database credentials secret"
  value       = aws_secretsmanager_secret.match_db.arn
}

output "redis_secret_arn" {
  description = "ARN of the Redis credentials secret"
  value       = aws_secretsmanager_secret.redis.arn
}

output "jwt_secret_arn" {
  description = "ARN of the JWT signing secret"
  value       = aws_secretsmanager_secret.jwt.arn
}