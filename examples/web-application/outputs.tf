output "load_balancer_dns_name" {
  description = "DNS name for the application load balancer."
  value       = module.application_load_balancer.load_balancer_dns_name
}

output "target_group_arn" {
  description = "Target group ARN."
  value       = module.application_load_balancer.target_group_arn
}

output "application_instance_id" {
  description = "Private application instance ID."
  value       = module.application_instance.instance_id
}
