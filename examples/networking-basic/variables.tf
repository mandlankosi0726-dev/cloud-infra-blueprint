variable "aws_region" {
  description = "AWS region selected by the operator."
  type        = string
}

variable "project_name" {
  description = "Non-sensitive project identifier."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "Non-overlapping VPC CIDR selected for this account and region."
  type        = string
}

variable "availability_zones" {
  description = "Distinct AZ names in this region."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "One CIDR per AZ, or empty when no public tier is needed."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "One CIDR per AZ, or empty when no private tier is needed."
  type        = list(string)
  default     = []
}

variable "nat_gateway_mode" {
  description = "none, single, or per_az; NAT incurs ongoing hourly and data processing charges."
  type        = string
  default     = "none"
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
