variable "name" {
  description = "Stable workload or platform name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,40}$", var.name))
    error_message = "name must be 1-40 characters and contain only letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment, such as development, staging, or production."
  type        = string

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC. Choose a range that does not overlap connected networks."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && try(tonumber(split("/", var.vpc_cidr)[1]) >= 16 && tonumber(split("/", var.vpc_cidr)[1]) <= 28, false)
    error_message = "vpc_cidr must be a valid IPv4 CIDR with a prefix from /16 through /28."
  }
}

variable "availability_zones" {
  description = "Availability zones used by this VPC. Supply one distinct zone per subnet tier entry."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "availability_zones must contain at least one unique zone."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs, one per selected AZ; set to an empty list when no public tier is needed."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr)) && try(tonumber(split("/", cidr)[1]) >= 16 && tonumber(split("/", cidr)[1]) <= 28, false)]) && length(distinct(var.public_subnet_cidrs)) == length(var.public_subnet_cidrs)
    error_message = "public_subnet_cidrs must contain unique IPv4 CIDRs with prefixes from /16 through /28."
  }
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs, one per selected AZ; private subnets never assign public IPs."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr)) && try(tonumber(split("/", cidr)[1]) >= 16 && tonumber(split("/", cidr)[1]) <= 28, false)]) && length(distinct(var.private_subnet_cidrs)) == length(var.private_subnet_cidrs)
    error_message = "private_subnet_cidrs must contain unique IPv4 CIDRs with prefixes from /16 through /28."
  }
}

variable "nat_gateway_mode" {
  description = "NAT choice for private subnets: none, single (lower cost, AZ dependency), or per_az (higher availability and cost)."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be none, single, or per_az."
  }
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional non-sensitive resource tags. Project, Environment, and ManagedBy are applied by the module."
  type        = map(string)
  default     = {}
}
