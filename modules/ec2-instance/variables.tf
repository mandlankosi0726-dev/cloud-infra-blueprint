variable "name" {
  description = "Instance name and Name tag."
  type        = string
}

variable "project" {
  description = "Project identifier for required resource tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required resource tags."
  type        = string
}

variable "ami_id" {
  description = "Explicit, approved AMI ID for the target region. Refresh through a reviewed image pipeline."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type selected for workload sizing."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for placement. Select a private subnet for private workloads."
  type        = string
}

variable "security_group_ids" {
  description = "Explicit security group IDs. At least one group is required."
  type        = set(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "security_group_ids must contain at least one security group."
  }
}

variable "iam_instance_profile_name" {
  description = "Optional instance profile name from an IAM role module."
  type        = string
  default     = null
}

variable "root_volume_size_gib" {
  description = "Encrypted root EBS volume size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size_gib >= 8 && var.root_volume_size_gib <= 16384
    error_message = "root_volume_size_gib must be from 8 through 16384 GiB."
  }
}

variable "root_volume_type" {
  description = "EBS root volume type."
  type        = string
  default     = "gp3"
}

variable "monitoring_enabled" {
  description = "Enable detailed EC2 monitoring, which incurs additional charges."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Optional bootstrap script. Never include credentials or long-lived secrets."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
