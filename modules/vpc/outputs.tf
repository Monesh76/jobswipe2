# modules/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}
output "database_security_group_id" {
  description = "ID of the security group for database access"
  value       = aws_security_group.database.id
}

output "redis_security_group_id" {
  description = "ID of the security group for Redis access"
  value       = aws_security_group.redis.id
}