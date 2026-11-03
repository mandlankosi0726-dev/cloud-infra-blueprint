output "role_name" {
  description = "IAM role name."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.this.arn
}

output "instance_profile_name" {
  description = "EC2 instance profile name, or null if create_instance_profile is false."
  value       = try(aws_iam_instance_profile.this[0].name, null)
}
