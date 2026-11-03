output "key_arn" {
  description = "KMS key ARN."
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "KMS key ID."
  value       = aws_kms_key.this.key_id
}

output "alias_name" {
  description = "Configured alias name, or null if none was created."
  value       = try(aws_kms_alias.this[0].name, null)
}
