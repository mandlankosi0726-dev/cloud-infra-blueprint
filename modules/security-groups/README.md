# Security groups module

Creates one VPC security group and adds only the explicitly supplied ingress and egress rules. Both rule lists default to empty; no SSH, database, or internet-wide rules are added. The module uses dedicated ingress/egress rule resources so peer security group references can express workload relationships.

Each rule requires a description, protocol, and exactly one of IPv4 CIDR, IPv6 CIDR, prefix list, or referenced security group ID. For protocols other than `-1`, provide a valid inclusive port range. Rule inputs are positional lists; keep their order stable to avoid unnecessary Terraform address changes. Avoid broad CIDRs and unrestricted egress; use the narrowest practical service destinations.

Inputs: `name`, `description`, `vpc_id`, `project`, `environment`, `ingress_rules`, `egress_rules`, and `tags`. Required Project, Environment, and ManagedBy tags are applied by the module. Outputs: `security_group_id` and `security_group_arn`. Example:

```hcl
module "app_sg" {
  source      = "../../modules/security-groups"
  name        = "app"
  description = "HTTPS from the approved load balancer group"
  vpc_id      = module.networking.vpc_id
  project     = "platform"
  environment = "production"
  ingress_rules = [{
    description                  = "Application HTTPS from ALB"
    ip_protocol                  = "tcp"
    from_port                    = 443
    to_port                      = 443
    referenced_security_group_id = module.alb_sg.security_group_id
  }]
  egress_rules = []
}
```

An empty rule list does not imply connectivity. Confirm AWS provider behavior and inspect the plan for default egress revocation. Security groups are stateful filters, not a substitute for network segmentation or application authentication. Run the repository validation and security scans before release. Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. No AWS integration test is included yet.
