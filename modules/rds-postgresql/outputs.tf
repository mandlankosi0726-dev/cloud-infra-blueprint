output "db_instance_id" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.id
}

output "db_endpoint_address" {
  description = "Private DNS endpoint address; network access is controlled by subnet and security group settings."
  value       = aws_db_instance.this.address
}

output "db_endpoint_port" {
  description = "PostgreSQL listener port."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Configured initial database name, or null."
  value       = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the RDS-managed Secrets Manager secret; no password is output."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}
