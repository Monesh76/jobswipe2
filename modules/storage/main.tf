# S3 bucket for storing profile images and documents
resource "aws_s3_bucket" "profile_storage" {
  bucket = "${var.app_name}-${var.environment}-profile-storage"

  tags = {
    Name        = "${var.app_name}-${var.environment}-profile-storage"
    Environment = var.environment
  }
}

# Enable versioning for profile storage bucket to maintain file history
resource "aws_s3_bucket_versioning" "profile_storage" {
  bucket = aws_s3_bucket.profile_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for security
resource "aws_s3_bucket_server_side_encryption_configuration" "profile_storage" {
  bucket = aws_s3_bucket.profile_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "profile_storage" {
  bucket = aws_s3_bucket.profile_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for application logs
resource "aws_s3_bucket" "application_logs" {
  bucket = "${var.app_name}-${var.environment}-logs"

  tags = {
    Name        = "${var.app_name}-${var.environment}-logs"
    Environment = var.environment
  }
}

# Enable encryption for logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.application_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.application_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policy for logs to manage storage costs
resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.application_logs.id

  rule {
    id     = "log_retention"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# IAM policy for accessing the storage buckets
resource "aws_iam_policy" "storage_access" {
  name        = "${var.app_name}-${var.environment}-storage-access"
  description = "Policy for accessing storage buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.profile_storage.arn,
          "${aws_s3_bucket.profile_storage.arn}/*",
          aws_s3_bucket.application_logs.arn,
          "${aws_s3_bucket.application_logs.arn}/*"
        ]
      }
    ]
  })
}