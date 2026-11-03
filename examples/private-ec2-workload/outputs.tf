output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = module.instance.instance_id
}

output "instance_private_ip" {
  description = "EC2 private IPv4 address."
  value       = module.instance.private_ip
}
