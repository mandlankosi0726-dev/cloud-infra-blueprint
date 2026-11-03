output "load_balancer_arn" {
  description = "Application load balancer ARN."
  value       = aws_lb.this.arn
}

output "load_balancer_dns_name" {
  description = "DNS name clients use to reach the load balancer."
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "Target group ARN for registering additional targets."
  value       = aws_lb_target_group.this.arn
}

output "https_listener_arn" {
  description = "HTTPS listener ARN."
  value       = aws_lb_listener.https.arn
}
