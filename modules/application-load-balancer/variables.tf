variable "name" {
  description = "Application load balancer and target group name prefix (maximum 24 characters)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]{0,22}[a-zA-Z0-9])?$", var.name))
    error_message = "name must contain 1-24 letters, numbers, or hyphens and start and end with a letter or number."
  }
}

variable "project" {
  description = "Project identifier for required resource tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required resource tags."
  type        = string
}

variable "internal" {
  description = "Create an internal load balancer. Defaults to internal; set false only for an explicitly public use case."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs for load balancer placement. Public load balancers require public subnets in at least two AZs."
  type        = set(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "An application load balancer must use at least two subnet IDs."
  }
}

variable "vpc_id" {
  description = "VPC ID containing the ALB subnets and targets."
  type        = string
}

variable "security_group_ids" {
  description = "Explicit security groups controlling allowed client traffic."
  type        = set(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group must be attached to the load balancer."
  }
}

variable "target_port" {
  description = "Backend target port."
  type        = number

  validation {
    condition     = var.target_port >= 1 && var.target_port <= 65535
    error_message = "target_port must be from 1 through 65535."
  }
}

variable "target_protocol" {
  description = "Protocol from the ALB to targets. TLS requires separate target group TLS configuration."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.target_protocol)
    error_message = "target_protocol must be HTTP or HTTPS."
  }
}

variable "target_type" {
  description = "Target type used by the target group."
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip"], var.target_type)
    error_message = "target_type must be instance or ip."
  }
}

variable "target_ids" {
  description = "Optional initial target IDs to register."
  type        = set(string)
  default     = []
}

variable "health_check_path" {
  description = "HTTP(S) target health check path."
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Expected HTTP response codes for a healthy target."
  type        = string
  default     = "200-399"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the required HTTPS listener."
  type        = string

  validation {
    condition     = length(trimspace(var.certificate_arn)) > 0
    error_message = "certificate_arn must be a non-empty ACM certificate ARN."
  }
}

variable "enable_http_redirect" {
  description = "Create an HTTP listener that redirects to HTTPS. Requires certificate_arn."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
