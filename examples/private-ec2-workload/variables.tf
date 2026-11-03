variable "aws_region" {
  description = "AWS region for this example."
  type        = string
}

variable "project_name" {
  description = "Non-sensitive project name."
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
  description = "Two or more distinct availability zones for private subnet placement."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per availability zone."
  type        = list(string)
}

variable "ami_id" {
  description = "Explicit approved AMI ID for aws_region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type selected for this workload."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size_gib" {
  description = "Encrypted root volume size in GiB."
  type        = number
  default     = 20
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring and its additional charges."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
