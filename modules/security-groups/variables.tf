variable "name" {
  description = "Security group name."
  type        = string
}

variable "description" {
  description = "Purpose of this security group."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the group will be created."
  type        = string
}

variable "project" {
  description = "Project or platform identifier for required resource tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required resource tags."
  type        = string
}

variable "ingress_rules" {
  description = "Explicit ingress rules. Each rule must have exactly one source selector."
  type = list(object({
    description                  = string
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([for rule in var.ingress_rules :
      length(compact([rule.cidr_ipv4, rule.cidr_ipv6, rule.prefix_list_id, rule.referenced_security_group_id])) == 1 &&
      (rule.ip_protocol == "-1" || (rule.from_port != null && rule.to_port != null && rule.from_port <= rule.to_port))
    ])
    error_message = "Each ingress rule needs exactly one source and either protocol -1 or an ordered port range."
  }
}

variable "egress_rules" {
  description = "Explicit egress rules. Empty means no user-defined egress rules are added."
  type = list(object({
    description                  = string
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([for rule in var.egress_rules :
      length(compact([rule.cidr_ipv4, rule.cidr_ipv6, rule.prefix_list_id, rule.referenced_security_group_id])) == 1 &&
      (rule.ip_protocol == "-1" || (rule.from_port != null && rule.to_port != null && rule.from_port <= rule.to_port))
    ])
    error_message = "Each egress rule needs exactly one destination and either protocol -1 or an ordered port range."
  }
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
