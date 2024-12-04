# modules/databases/main.tf

# This parameter group defines database-specific settings
resource "aws_db_parameter_group" "postgres" {
  family = "postgres14"
  name   = "${var.app_name}-${var.environment}-pg"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

# Subnet group to place RDS instances in the correct VPC subnets
resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-${var.environment}-db-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.app_name}-${var.environment}-db-subnet"
    Environment = var.environment
  }
}

# Profile Database
resource "aws_db_instance" "profile_db" {
  identifier           = "${var.app_name}-${var.environment}-profile"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  storage_encrypted   = true
  
  db_name             = "profile_db"
  username            = "profile_admin"
  password            = random_password.profile_db_password.result
  
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.postgres.name
  
  backup_retention_period = 7
  multi_az               = true
  skip_final_snapshot    = true
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-profile-db"
    Environment = var.environment
  }
}

# Match Database
resource "aws_db_instance" "match_db" {
  identifier           = "${var.app_name}-${var.environment}-match"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  storage_encrypted   = true
  
  db_name             = "match_db"
  username            = "match_admin"
  password            = random_password.match_db_password.result
  
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.postgres.name
  
  backup_retention_period = 7
  multi_az               = true
  skip_final_snapshot    = true
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-match-db"
    Environment = var.environment
  }
}

# Database passwords in Secrets Manager
resource "aws_secretsmanager_secret" "profile_db_password" {
  name = "${var.app_name}-${var.environment}-profile-db-password"
  description = "Password for Profile database"

  tags = {
    Name        = "${var.app_name}-${var.environment}-profile-db-password"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "profile_db_password" {
  secret_id     = aws_secretsmanager_secret.profile_db_password.id
  secret_string = random_password.profile_db_password.result
}

resource "aws_secretsmanager_secret" "match_db_password" {
  name = "${var.app_name}-${var.environment}-match-db-password"
  description = "Password for Match database"
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-match-db-password"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "match_db_password" {
  secret_id     = aws_secretsmanager_secret.match_db_password.id
  secret_string = random_password.match_db_password.result
}

resource "random_password" "profile_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?" # Removed problematic characters
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}
resource "random_password" "match_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?" # Only allowed special characters
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}
# Generate secure passwords
#resource "random_password" "profile_db_password" {
#  length  = 16
#  special = true
#}

#resource "random_password" "match_db_password" {
#  length  = 16
#  special = true
#}


