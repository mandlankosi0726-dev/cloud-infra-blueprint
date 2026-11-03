output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Primary private IPv4 address."
  value       = aws_instance.this.private_ip
}

output "instance_arn" {
  description = "EC2 instance ARN."
  value       = aws_instance.this.arn
}
