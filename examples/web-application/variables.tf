variable "aws_region" {
  description = "AWS region for this example."
  type        = string
}

variable "project_name" {
  description = "Short project name used in AWS resource names."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "Non-overlapping VPC CIDR."
  type        = string
}

variable "availability_zones" {
  description = "At least two selected availability zones."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per selected AZ."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per selected AZ."
  type        = list(string)
}

variable "client_cidrs" {
  description = "Explicit client IPv4 CIDRs permitted to reach the public HTTPS listener. Avoid 0.0.0.0/0 unless the application is intended for the public internet."
  type        = set(string)

  validation {
    condition     = length(var.client_cidrs) > 0
    error_message = "Provide at least one explicitly approved client CIDR."
  }
}

variable "ami_id" {
  description = "Explicit approved AMI ID for the selected region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "application_port" {
  description = "Port on which the application accepts traffic from the ALB."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Application health-check path served by the target."
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "Existing ACM certificate ARN in this region for HTTPS."
  type        = string
}

variable "enable_http_redirect" {
  description = "Whether to accept HTTP from the approved client CIDRs and redirect to HTTPS."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
