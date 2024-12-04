# Outputs
output "profile_db_endpoint" {
  value = aws_db_instance.profile_db.endpoint
}

output "match_db_endpoint" {
  value = aws_db_instance.match_db.endpoint
}

output "profile_db_name" {
  value = aws_db_instance.profile_db.db_name
}

output "match_db_name" {
  value = aws_db_instance.match_db.db_name
}