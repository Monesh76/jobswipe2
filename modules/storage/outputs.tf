output "profile_storage_bucket" {
  value = aws_s3_bucket.profile_storage.id
}

output "logs_bucket" {
  value = aws_s3_bucket.application_logs.id
}

output "storage_access_policy_arn" {
  value = aws_iam_policy.storage_access.arn
}